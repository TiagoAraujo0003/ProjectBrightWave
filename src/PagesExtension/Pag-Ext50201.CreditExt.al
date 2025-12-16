pageextension 50201 "Credit Ext" extends "Customer Card"
{
    layout
    {
        addbefore("Credit Limit (LCY)")
        {
            field("Credit Rating";Rec."Credit Rating")
            {
                ApplicationArea= all;
            }
        }
    }
}