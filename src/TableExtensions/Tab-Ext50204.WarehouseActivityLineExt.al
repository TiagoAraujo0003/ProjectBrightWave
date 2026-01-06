tableextension 50204 "Warehouse Activity Line Ext" extends "Warehouse Activity Line"
{
    fields
    {
        field(50200; "Box No."; Code[20])
        {
            Caption = 'Box No.';
            TableRelation = "Warehouse Box" where(Status = filter(Available | "In Use"),
                                                   "Location Code" = field("Location Code"));
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                WhseBox: Record "Warehouse Box";
                WhseBoxMgt: Codeunit "Warehouse Box Management";
            begin
                if "Box No." = '' then
                    exit;

                // Verify box is available for this pick
                if not WhseBox.Get("Box No.") then
                    Error('Box %1 does not exist.', "Box No.");

                // Boxes cannot be reused - must be Available
                if WhseBox.Status = WhseBox.Status::Shipped then
                    Error('Box %1 has already been shipped and cannot be reused.', "Box No.");

                // Check location
                WhseBox.TestField("Location Code", "Location Code");

                // If box is in use, verify it's for this pick
                if WhseBox.Status = WhseBox.Status::"In Use" then begin
                    if WhseBox."Whse. Activity No." <> "No." then
                        Error('Box %1 is already assigned to another pick (%2).', "Box No.", WhseBox."Whse. Activity No.");
                end;

                // Check if this is a Take line (should not have box)
                if "Action Type" = "Action Type"::Take then
                    Error('Box assignment is only allowed for Place lines.');

                // Validate capacity if configured
                WhseBoxMgt.ValidateBoxCapacity("Box No.", "Item No.", "Qty. to Handle");
            end;

            trigger OnLookup()
            var
                WhseBox: Record "Warehouse Box";
                WhseBoxList: Page "Warehouse Box List";
            begin
                WhseBox.SetRange("Location Code", "Location Code");
                WhseBox.SetFilter(Status, '%1|%2', WhseBox.Status::Available, WhseBox.Status::"In Use");

                // If box is in use, only show boxes for this pick
                WhseBox.SetFilter("Whse. Activity No.", '%1|%2', '', "No.");

                WhseBoxList.SetTableView(WhseBox);
                WhseBoxList.LookupMode := true;
                if WhseBoxList.RunModal() = Action::LookupOK then begin
                    WhseBoxList.GetRecord(WhseBox);
                    Validate("Box No.", WhseBox."Box No.");
                end;
            end;
        }
        field(50201; "Box Assigned"; Boolean)
        {
            Caption = 'Box Assigned';
            FieldClass = FlowField;
            CalcFormula = exist("Warehouse Box Content" where("Whse. Activity No." = field("No."),
                                                                "Whse. Activity Line No." = field("Line No.")));
            Editable = false;
        }
    }
}
