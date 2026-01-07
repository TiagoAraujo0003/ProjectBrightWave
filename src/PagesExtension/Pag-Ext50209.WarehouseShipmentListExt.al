pageextension 50209 "Warehouse Shipment List Ext" extends "Warehouse Shipment List"
{
    layout
    {
        addafter("Location Code")
        {
            field("Box No."; Rec."Box No.")
            {
                ApplicationArea = Warehouse;
                Caption = 'Box No.';
            }
        }
    }
}
