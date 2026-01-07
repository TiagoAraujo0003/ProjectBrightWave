pageextension 50207 "Customers Ext" extends "Customer List"
{
    layout
    {
        addafter(Name)
        {
            field("Credit Rating"; Rec."Credit Rating")
            {
                ApplicationArea = All;
                caption = 'Credit Rating';
            }
        }
    }
}