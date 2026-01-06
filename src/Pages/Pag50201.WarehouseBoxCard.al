page 50201 "Warehouse Box Card"
{
    PageType = Card;
    ApplicationArea = Warehouse;
    SourceTable = "Warehouse Box";
    Caption = 'Warehouse Box Card';

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

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
                    ToolTip = 'Specifies the status of the box.';
                }
            }
            group(Capacity)
            {
                Caption = 'Capacity';

                field("Max Weight (kg)"; Rec."Max Weight (kg)")
                {
                    ApplicationArea = Warehouse;
                    ToolTip = 'Specifies the maximum weight capacity of the box.';
                }
                field("Current Weight (kg)"; Rec."Current Weight (kg)")
                {
                    ApplicationArea = Warehouse;
                    ToolTip = 'Specifies the current weight of items in the box.';
                    Style = Attention;
                    StyleExpr = WeightExceeded;
                }
                field("Max Volume (cm³)"; Rec."Max Volume (cm³)")
                {
                    ApplicationArea = Warehouse;
                    ToolTip = 'Specifies the maximum volume capacity of the box.';
                }
                field("Current Volume (cm³)"; Rec."Current Volume (cm³)")
                {
                    ApplicationArea = Warehouse;
                    ToolTip = 'Specifies the current volume of items in the box.';
                    Style = Attention;
                    StyleExpr = VolumeExceeded;
                }
            }
            group(Assignment)
            {
                Caption = 'Assignment';

                field("Whse. Activity No."; Rec."Whse. Activity No.")
                {
                    ApplicationArea = Warehouse;
                    ToolTip = 'Specifies the warehouse activity number.';
                }
                field("Whse. Shipment No."; Rec."Whse. Shipment No.")
                {
                    ApplicationArea = Warehouse;
                    ToolTip = 'Specifies the warehouse shipment number.';
                }
                field("Sales Order No."; Rec."Sales Order No.")
                {
                    ApplicationArea = Warehouse;
                    ToolTip = 'Specifies the sales order number.';
                }
                field("Assigned Date"; Rec."Assigned Date")
                {
                    ApplicationArea = Warehouse;
                    ToolTip = 'Specifies when the box was assigned.';
                }
                field("Shipped Date"; Rec."Shipped Date")
                {
                    ApplicationArea = Warehouse;
                    ToolTip = 'Specifies when the box was shipped.';
                }
            }
            group(Tracking)
            {
                Caption = 'Tracking';

                field("Created Date"; Rec."Created Date")
                {
                    ApplicationArea = Warehouse;
                    ToolTip = 'Specifies when the box was created.';
                }
                field("Created By"; Rec."Created By")
                {
                    ApplicationArea = Warehouse;
                    ToolTip = 'Specifies who created the box.';
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
        area(Navigation)
        {
            action(Contents)
            {
                ApplicationArea = Warehouse;
                Caption = 'Contents';
                ToolTip = 'View the contents of this box.';
                Image = ViewDetails;
                RunObject = page "Warehouse Box Contents";
                RunPageLink = "Box No." = field("Box No.");
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
    end;

    var
        WeightExceeded: Boolean;
        VolumeExceeded: Boolean;
}
