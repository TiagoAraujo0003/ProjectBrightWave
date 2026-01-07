pageextension 50210 "Warehouse Shipment Ext" extends "Warehouse Shipment"
{
    layout
    {
        addafter("Sorting Method")
        {
            field("Box No."; Rec."Box No.")
            {
                ApplicationArea = Warehouse;
                Caption = 'Box No.';
                Editable = false;
            }
        }
    }
}