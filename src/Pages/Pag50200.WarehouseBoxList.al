page 50200 "Warehouse Box List"
{
    PageType = List;
    ApplicationArea = Warehouse;
    UsageCategory = Lists;
    SourceTable = "Warehouse Box";
    Caption = 'Warehouse Boxes';
    CardPageId = "Warehouse Box Card";
    Editable = true;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Box No."; Rec."Box No.")
                {
                    ApplicationArea = Warehouse;
                    ToolTip = 'Specifies the box number.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Warehouse;
                    ToolTip = 'Specifies the description of the box.';
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = Warehouse;
                    ToolTip = 'Specifies the location code where the box is available.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Warehouse;
                    ToolTip = 'Specifies the status of the box (Available, In Use, or Shipped).';
                    StyleExpr = StatusStyleExpr;
                }
                field("Whse. Activity No."; Rec."Whse. Activity No.")
                {
                    ApplicationArea = Warehouse;
                    ToolTip = 'Specifies the warehouse activity number if the box is in use.';
                    Visible = false;
                }
                field("Whse. Shipment No."; Rec."Whse. Shipment No.")
                {
                    ApplicationArea = Warehouse;
                    ToolTip = 'Specifies the warehouse shipment number related to this box.';
                }
                field("Sales Order No."; Rec."Sales Order No.")
                {
                    ApplicationArea = Warehouse;
                    ToolTip = 'Specifies the sales order number related to this box.';
                }
                field("Max Weight (kg)"; Rec."Max Weight (kg)")
                {
                    ApplicationArea = Warehouse;
                    ToolTip = 'Specifies the maximum weight capacity of the box.';
                    Visible = false;
                }
                field("Max Volume (cm³)"; Rec."Max Volume (cm³)")
                {
                    ApplicationArea = Warehouse;
                    ToolTip = 'Specifies the maximum volume capacity of the box.';
                    Visible = false;
                }
                field("Current Weight (kg)"; Rec."Current Weight (kg)")
                {
                    ApplicationArea = Warehouse;
                    ToolTip = 'Specifies the current weight of items in the box.';
                    Style = Attention;
                    StyleExpr = WeightExceeded;
                }
                field("Current Volume (cm³)"; Rec."Current Volume (cm³)")
                {
                    ApplicationArea = Warehouse;
                    ToolTip = 'Specifies the current volume of items in the box.';
                    Style = Attention;
                    StyleExpr = VolumeExceeded;
                }
                field("Created Date"; Rec."Created Date")
                {
                    ApplicationArea = Warehouse;
                    ToolTip = 'Specifies when the box was created.';
                    Visible = false;
                }
                field("Assigned Date"; Rec."Assigned Date")
                {
                    ApplicationArea = Warehouse;
                    ToolTip = 'Specifies when the box was assigned to a pick.';
                    Visible = false;
                }
            }
        }
        area(FactBoxes)
        {
            part(BoxContents; "Warehouse Box Contents FB")
            {
                ApplicationArea = Warehouse;
                SubPageLink = "Box No." = field("Box No.");
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ViewContents)
            {
                ApplicationArea = Warehouse;
                Caption = 'View Contents';
                ToolTip = 'View the contents of the selected box.';
                Image = ViewDetails;
                RunObject = page "Warehouse Box Contents";
                RunPageLink = "Box No." = field("Box No.");
            }
            action(CreateNewBoxes)
            {
                ApplicationArea = Warehouse;
                Caption = 'Create Multiple Boxes';
                ToolTip = 'Create multiple boxes with sequential numbers.';
                Image = AddAction;

                trigger OnAction()
                var
                    CreateBoxesMgt: Codeunit "Warehouse Box Management";
                begin
                    CreateBoxesMgt.CreateMultipleBoxes();
                    CurrPage.Update(false);
                end;
            }
        }
        area(Navigation)
        {
            action(WarehouseShipment)
            {
                ApplicationArea = Warehouse;
                Caption = 'Warehouse Shipment';
                ToolTip = 'View the warehouse shipment related to this box.';
                Image = Shipment;
                Enabled = Rec."Whse. Shipment No." <> '';

                trigger OnAction()
                var
                    WhseShptHeader: Record "Warehouse Shipment Header";
                    WhseShipmentPage: Page "Warehouse Shipment";
                begin
                    if WhseShptHeader.Get(Rec."Whse. Shipment No.") then begin
                        WhseShipmentPage.SetRecord(WhseShptHeader);
                        WhseShipmentPage.Run();
                    end;
                end;
            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                Caption = 'Process';

                actionref(ViewContents_Promoted; ViewContents) { }
                actionref(CreateNewBoxes_Promoted; CreateNewBoxes) { }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        UpdateStyleExpressions();
    end;

    local procedure UpdateStyleExpressions()
    begin
        Rec.CalcFields("Current Weight (kg)", "Current Volume (cm³)");

        WeightExceeded := (Rec."Max Weight (kg)" > 0) and (Rec."Current Weight (kg)" > Rec."Max Weight (kg)");
        VolumeExceeded := (Rec."Max Volume (cm³)" > 0) and (Rec."Current Volume (cm³)" > Rec."Max Volume (cm³)");

        case Rec.Status of
            Rec.Status::Available:
                StatusStyleExpr := 'Favorable';
            Rec.Status::"In Use":
                StatusStyleExpr := 'Attention';
            Rec.Status::Shipped:
                StatusStyleExpr := 'Subordinate';
        end;
    end;

    var
        StatusStyleExpr: Text;
        WeightExceeded: Boolean;
        VolumeExceeded: Boolean;
}
