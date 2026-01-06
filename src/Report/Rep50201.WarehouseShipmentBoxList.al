report 50201 "Warehouse Shipment Box List"
{
    Caption = 'Warehouse Shipment Box List';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = Warehouse;
    DefaultRenderingLayout = RDLCLayout;

    dataset
    {
        dataitem(WarehouseShipmentHeader; "Warehouse Shipment Header")
        {
            RequestFilterFields = "No.", "Location Code", "Shipment Date";

            column(CompanyName; CompanyProperty.DisplayName()) { }
            column(ReportTitle; ReportTitleLbl) { }
            column(No_WhseShptHeader; "No.") { }
            column(LocationCode_WhseShptHeader; "Location Code") { }
            column(ShipmentDate_WhseShptHeader; "Shipment Date") { }
            column(ExternalDocumentNo; "External Document No.") { }
            column(ShippingAgentCode; "Shipping Agent Code") { }

            dataitem(WarehouseBox; "Warehouse Box")
            {
                DataItemLink = "Whse. Shipment No." = field("No.");
                DataItemTableView = sorting("Box No.");

                column(BoxNo_WhseBox; "Box No.") { }
                column(BoxDescription_WhseBox; Description) { }
                column(BoxStatus_WhseBox; Status) { }
                column(CurrentWeight_WhseBox; "Current Weight (kg)") { }
                column(CurrentVolume_WhseBox; "Current Volume (cm³)") { }
                column(MaxWeight_WhseBox; "Max Weight (kg)") { }
                column(MaxVolume_WhseBox; "Max Volume (cm³)") { }
                column(SalesOrderNo_WhseBox; "Sales Order No.") { }

                dataitem(WarehouseBoxContent; "Warehouse Box Content")
                {
                    DataItemLink = "Box No." = field("Box No."),
                                   "Whse. Shipment No." = field("Whse. Shipment No.");
                    DataItemTableView = sorting("Box No.", "Entry No.");

                    column(ItemNo_BoxContent; "Item No.") { }
                    column(ItemDescription_BoxContent; "Item Description") { }
                    column(VariantCode_BoxContent; "Variant Code") { }
                    column(Quantity_BoxContent; Quantity) { }
                    column(UnitOfMeasure_BoxContent; "Unit of Measure Code") { }
                    column(TotalWeight_BoxContent; "Total Weight") { }
                    column(TotalVolume_BoxContent; "Total Volume") { }
                    column(BinCode_BoxContent; "Bin Code") { }
                    column(SourceNo_BoxContent; "Source No.") { }

                    trigger OnAfterGetRecord()
                    begin
                        TotalItemsInBox += 1;
                        BoxTotalQty += Quantity;
                    end;

                    trigger OnPreDataItem()
                    begin
                        TotalItemsInBox := 0;
                        BoxTotalQty := 0;
                    end;
                }

                column(TotalItemsInBox; TotalItemsInBox) { }
                column(BoxTotalQty; BoxTotalQty) { }

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

            trigger OnAfterGetRecord()
            begin
                TotalShipments += 1;
            end;

            trigger OnPreDataItem()
            begin
                TotalShipments := 0;
            end;
        }
    }

    rendering
    {
        layout(RDLCLayout)
        {
            Type = RDLC;
            LayoutFile = 'WarehouseShipmentBoxList.rdl';
        }
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
    }

    var
        ReportTitleLbl: Label 'Warehouse Shipment - Box List';
        TotalBoxesInShipment: Integer;
        TotalItemsInBox: Integer;
        TotalShipments: Integer;
        BoxTotalQty: Decimal;
}
