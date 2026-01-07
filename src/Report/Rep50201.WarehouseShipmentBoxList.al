report 50201 "Warehouse Shipment Box List"
{
    Caption = 'Warehouse Shipment Box List';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = Warehouse;
    DefaultRenderingLayout = WordLayout;

    dataset
    {
        dataitem(PostedWhseShipmentHeader; "Posted Whse. Shipment Header")
        {
            RequestFilterFields = "No.", "Location Code", "Shipment Date";

            column(CompanyName; CompanyProperty.DisplayName()) { }
            column(ReportTitle; ReportTitleLbl) { }
            column(No_WhseShptHeader; "No.") { }
            column(LocationCode_WhseShptHeader; "Location Code") { }
            column(ShipmentDate_WhseShptHeader; "Shipment Date") { }
            column(ExternalDocumentNo; "External Document No.") { }
            column(ShippingAgentCode; "Shipping Agent Code") { }
            column(CustomerName; CustomerName) { }
            column(CustomerAddress; CustomerAddress) { }

            dataitem(PostedWhseShipmentLine; "Posted Whse. Shipment Line")
            {
                DataItemLink = "No." = field("No.");
                DataItemTableView = sorting("No.", "Line No.");

                column(ItemNo_Line; "Item No.") { }
                column(ItemDescription_Line; Description) { }
                column(Quantity_Line; Quantity) { }
                column(UnitOfMeasure_Line; "Unit of Measure Code") { }
                column(BoxNo_Line; "Box No.") { }
                column(SourceNo_Line; "Source No.") { }
                column(BinCode_Line; "Bin Code") { }

                trigger OnAfterGetRecord()
                begin
                    TotalItemsInShipment += 1;
                end;
            }

            dataitem(WarehouseBox; "Warehouse Box")
            {
                DataItemLink = "Whse. Shipment No." = field("Whse. Shipment No.");
                DataItemTableView = sorting("Box No.");

                column(BoxNo_WhseBox; "Box No.") { }
                column(BoxDescription_WhseBox; Description) { }
                column(BoxStatus_WhseBox; Status) { }
                column(CurrentWeight_WhseBox; "Current Weight (kg)") { }
                column(CurrentVolume_WhseBox; "Current Volume (cm³)") { }

                trigger OnAfterGetRecord()
                begin
                    CalcFields("Current Weight (kg)", "Current Volume (cm³)");
                    TotalBoxesInShipment += 1;
                end;

                trigger OnPreDataItem()
                begin
                    TotalBoxesInShipment := 0;
                end;
            }

            column(TotalBoxesInShipment; TotalBoxesInShipment) { }
            column(TotalItemsInShipment; TotalItemsInShipment) { }

            trigger OnAfterGetRecord()
            var
                Customer: Record Customer;
                SalesHeader: Record "Sales Header";
            begin
                TotalItemsInShipment := 0;

                // Get customer info from the first line's source
                PostedWhseShipmentLine.Reset();
                PostedWhseShipmentLine.SetRange("No.", "No.");
                if PostedWhseShipmentLine.FindFirst() then begin
                    if Customer.Get(PostedWhseShipmentLine."Destination No.") then begin
                        CustomerName := Customer.Name;
                        CustomerAddress := Customer.Address + ', ' + Customer."Post Code" + ' ' + Customer.City;
                    end;
                end;
            end;
        }
    }

    rendering
    {
        layout(WordLayout)
        {
            Type = Word;
            LayoutFile = 'WarehouseShipmentBoxList.docx';
        }
    }

    labels
    {
        ShipmentNoLbl = 'Shipment No.';
        LocationLbl = 'Location';
        ShipmentDateLbl = 'Shipment Date';
        BoxNoLbl = 'Box No.';
        BoxDescriptionLbl = 'Description';
        StatusLbl = 'Status';
        WeightLbl = 'Weight (kg)';
        VolumeLbl = 'Volume (cm³)';
        ItemNoLbl = 'Item No.';
        DescriptionLbl = 'Description';
        QuantityLbl = 'Quantity';
        UoMLbl = 'UoM';
        TotalBoxesLbl = 'Total Boxes';
        BoxContentsLbl = 'Box Contents';
        PageLbl = 'Page';
        CustomerLbl = 'Customer';
    }

    var
        ReportTitleLbl: Label 'Shipment Detail';
        TotalBoxesInShipment: Integer;
        TotalItemsInShipment: Integer;
        CustomerName: Text[100];
        CustomerAddress: Text[250];
}
