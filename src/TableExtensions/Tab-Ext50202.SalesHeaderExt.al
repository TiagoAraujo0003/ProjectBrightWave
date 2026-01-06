tableextension 50202 "Sales Header Ext" extends "Sales Header"
{
    fields
    {
        field(50202; "Credit Rating"; Enum "Credit Rating")
        {
            FieldClass = FlowField;
            CalcFormula = lookup(Customer."Credit Rating" where("No." = field("Sell-to Customer No.")));
            Editable = false;
        }
    }
}