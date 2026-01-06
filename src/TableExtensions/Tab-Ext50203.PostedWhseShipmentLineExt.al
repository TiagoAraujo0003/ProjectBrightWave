tableextension 50203 "Posted Whse. Shipment Line Ext" extends "Posted Whse. Shipment Line"
{
    fields
    {
        field(50200; "Box No."; Code[20])
        {
            Caption = 'Box No.';
            TableRelation = "Warehouse Box";
            DataClassification = CustomerContent;
            Editable = false;
        }
    }
}
