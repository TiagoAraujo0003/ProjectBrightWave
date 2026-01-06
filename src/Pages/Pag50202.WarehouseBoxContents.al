page 50202 "Warehouse Box Contents"
{
    PageType = List;
    ApplicationArea = Warehouse;
    SourceTable = "Warehouse Box Content";
    Caption = 'Warehouse Box Contents';
    Editable = false;

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
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = Warehouse;
                    ToolTip = 'Specifies the item number.';
                }
                field("Item Description"; Rec."Item Description")
                {
                    ApplicationArea = Warehouse;
                    ToolTip = 'Specifies the item description.';
                }
                field("Variant Code"; Rec."Variant Code")
                {
                    ApplicationArea = Warehouse;
                    ToolTip = 'Specifies the variant code.';
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Warehouse;
                    ToolTip = 'Specifies the quantity.';
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = Warehouse;
                    ToolTip = 'Specifies the unit of measure.';
                }
                field("Total Weight"; Rec."Total Weight")
                {
                    ApplicationArea = Warehouse;
                    ToolTip = 'Specifies the total weight.';
                }
                field("Total Volume"; Rec."Total Volume")
                {
                    ApplicationArea = Warehouse;
                    ToolTip = 'Specifies the total volume.';
                }
                field("Whse. Shipment No."; Rec."Whse. Shipment No.")
                {
                    ApplicationArea = Warehouse;
                    ToolTip = 'Specifies the warehouse shipment number.';
                }
                field("Source No."; Rec."Source No.")
                {
                    ApplicationArea = Warehouse;
                    ToolTip = 'Specifies the source document number.';
                }
            }
        }
    }
}
