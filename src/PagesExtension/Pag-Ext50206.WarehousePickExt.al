pageextension 50206 "Warehouse Pick Ext" extends "Warehouse Pick"
{
    actions
    {
        addfirst(Processing)
        {
            action(RegisterPickWithBoxes)
            {
                ApplicationArea = Warehouse;
                Caption = 'Register Pick with Boxes';
                ToolTip = 'Register the pick and create box content entries.';
                Image = RegisterPick;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    WhseBoxMgt: Codeunit "Warehouse Box Management";
                    WhseActRegister: Codeunit "Whse.-Activity-Register";
                    WhseActivityLine: Record "Warehouse Activity Line";
                    WhseActivityHeader: Record "Warehouse Activity Header";
                    PickHeaderNotFoundLbl: Label 'Pick No. %1 not found.', Comment = '%1 - Pick No.';
                begin
                    // Get header before registration
                    if not WhseActivityHeader.Get(Rec.Type, Rec."No.") then
                        Error(PickHeaderNotFoundLbl, Rec."No.");

                    // Validate boxes first
                    //WhseBoxMgt.ValidateBoxAssignment(Rec."No.");

                    // Register boxes BEFORE standard registration (creates box content entries)
                    WhseBoxMgt.RegisterPickWithBoxes(WhseActivityHeader);

                    // Get first line for standard registration
                    WhseActivityLine.Reset();
                    WhseActivityLine.SetRange("Activity Type", Rec.Type);
                    WhseActivityLine.SetRange("No.", Rec."No.");
                    if WhseActivityLine.IsEmpty() then
                        Error('No lines found to register.');

                    // Standard registration (this will delete the pick)´
                    WhseActivityLine.FindSet();
                    WhseActRegister.Run(WhseActivityLine);

                    Message('Pick registered successfully with boxes.');
                    CurrPage.Update(false);
                end;
            }
            action(ValidateBoxAssignment)
            {
                ApplicationArea = Warehouse;
                Caption = 'Validate Box Assignment';
                ToolTip = 'Check if all place lines have boxes assigned before registration.';
                Image = CheckList;

                trigger OnAction()
                var
                    WhseBoxMgt: Codeunit "Warehouse Box Management";
                begin
                    WhseBoxMgt.ValidateBoxAssignment(Rec."No.");
                    Message('All place lines have boxes assigned correctly.');
                end;
            }
            action(ViewBoxes)
            {
                ApplicationArea = Warehouse;
                Caption = 'View Assigned Boxes';
                ToolTip = 'View the boxes assigned to this pick.';
                Image = ViewDetails;

                trigger OnAction()
                var
                    WhseBox: Record "Warehouse Box";
                    WhseBoxList: Page "Warehouse Box List";
                begin
                    WhseBox.SetRange("Whse. Activity No.", Rec."No.");
                    WhseBoxList.SetTableView(WhseBox);
                    WhseBoxList.Run();
                end;
            }
        }
    }
}
