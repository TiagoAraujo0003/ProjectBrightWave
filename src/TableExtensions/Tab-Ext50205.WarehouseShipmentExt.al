tableextension 50205 "Warehouse Shipment Ext" extends "Warehouse Shipment Header"
{
    fields
    {
        field(50200; "Box No."; Code[20])
        {
            Caption = 'Box No.';
            TableRelation = "Warehouse Box"."Box No." where("Whse. Shipment No." = field("No."));
            DataClassification = CustomerContent;
        }
    }
}