enum 50201 "Warehouse Box Status"
{
    Extensible = true;
    Caption = 'Warehouse Box Status';

    value(0; Available)
    {
        Caption = 'Available';
    }
    value(1; "In Use")
    {
        Caption = 'In Use';
    }
    value(2; Shipped)
    {
        Caption = 'Shipped';
    }
}
