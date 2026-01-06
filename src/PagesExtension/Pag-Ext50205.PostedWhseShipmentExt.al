pageextension 50205 "Posted Whse. Shipment Ext" extends "Posted Whse. Shipment"
{
    actions
    {
        addafter("&Shipment")
        {
            action(BoxList)
            {
                ApplicationArea = Warehouse;
                Caption = 'Box List Report';
                ToolTip = 'View a report showing all boxes used in this shipment and their contents.';
                Image = Report;
                RunObject = report "Warehouse Shipment Box List";
            }
        }
    }
}
