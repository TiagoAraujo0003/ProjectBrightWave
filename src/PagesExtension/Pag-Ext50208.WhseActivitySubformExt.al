pageextension 50208 "Whse. Activity Subform Ext" extends "Whse. Pick Subform"
{
    layout
    {
        addafter("Bin Code")
        {
            field("Box No."; Rec."Box No.")
            {
                ApplicationArea = All;
            }
        }
    }
}
