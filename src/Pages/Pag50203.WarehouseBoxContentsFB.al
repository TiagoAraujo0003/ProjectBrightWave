page 50203 "Warehouse Box Contents FB"
{
    PageType = ListPart;
    ApplicationArea = Warehouse;
    SourceTable = "Warehouse Box Content";
    Caption = 'Box Contents';
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
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
            }
        }
    }
}
