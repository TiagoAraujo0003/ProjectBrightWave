pageextension 50204 "Sales Order Extension" extends "Sales Order"
{
    layout
    {
        addafter("Sell-to Customer Name")
        {
            field("Credit Rating"; Rec."Credit Rating")
            {
                ApplicationArea = All;
                Editable = False;
            }
        }
    }
}
