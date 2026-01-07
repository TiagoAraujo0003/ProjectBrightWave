page 50204 "Quantity Input Dialog"
{
    PageType = StandardDialog;
    Caption = 'Create Multiple Boxes';

    layout
    {
        area(Content)
        {
            group(Options)
            {
                Caption = 'Options';

                field(QuantityField; Quantity)
                {
                    ApplicationArea = Warehouse;
                    Caption = 'Number of Boxes to Create';
                    ToolTip = 'Specifies the number of boxes to create (1-100).';
                    MinValue = 1;
                    MaxValue = 100;
                }
            }
        }
    }

    var
        Quantity: Integer;

    procedure SetQuantity(NewQuantity: Integer)
    begin
        Quantity := NewQuantity;
    end;

    procedure GetQuantity(): Integer
    begin
        exit(Quantity);
    end;
}
