report 50202 "Warehouse Box Labels"
{
    Caption = 'Warehouse Box Labels';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultRenderingLayout = wordLayout;

    dataset
    {
        dataitem(WarehouseBox; "Warehouse Box")
        {
            DataItemTableView = sorting("Box No.");
            RequestFilterFields = "Box No.", "Whse. Shipment No.";

            column(BoxNo; "Box No.") { }
            column(WhseShipmentNo; "Whse. Shipment No.") { }
            column(CustomerName; CustomerName) { }
            column(CustomerAddress; CustomerAddress) { }
            column(CustomerCity; CustomerCity) { }
            column(CustomerPostCode; CustomerPostCode) { }
            column(CustomerCountry; CustomerCountry) { }

            trigger OnAfterGetRecord()
            var
                WhseShipmentLine: Record "Warehouse Shipment Line";
                PostedWhseShipmentLine: Record "Posted Whse. Shipment Line";
                SalesHeader: Record "Sales Header";
                SalesShipmentHeader: Record "Sales Shipment Header";
                Customer: Record Customer;
            begin
                // Limpar variáveis
                CustomerName := '';
                CustomerAddress := '';
                CustomerCity := '';
                CustomerPostCode := '';
                CustomerCountry := '';

                if "Whse. Shipment No." = '' then
                    exit;

                // Tentar primeiro o Posted Warehouse Shipment (se já foi enviado)
                PostedWhseShipmentLine.SetRange("Whse. Shipment No.", "Whse. Shipment No.");
                if PostedWhseShipmentLine.FindFirst() then begin
                    if PostedWhseShipmentLine."Source Type" = Database::"Sales Line" then begin
                        // Obter o Sales Shipment Header
                        SalesShipmentHeader.SetRange("Order No.", PostedWhseShipmentLine."Source No.");
                        if SalesShipmentHeader.FindFirst() then begin
                            if Customer.Get(SalesShipmentHeader."Sell-to Customer No.") then begin
                                CustomerName := Customer.Name;
                                CustomerAddress := Customer.Address;
                                CustomerCity := Customer.City;
                                CustomerPostCode := Customer."Post Code";
                                CustomerCountry := Customer."Country/Region Code";
                                exit;
                            end;
                        end;
                        // Se não encontrou o shipment, tenta a Sales Order diretamente
                        if SalesHeader.Get(SalesHeader."Document Type"::Order, PostedWhseShipmentLine."Source No.") then begin
                            if Customer.Get(SalesHeader."Sell-to Customer No.") then begin
                                CustomerName := Customer.Name;
                                CustomerAddress := Customer.Address;
                                CustomerCity := Customer.City;
                                CustomerPostCode := Customer."Post Code";
                                CustomerCountry := Customer."Country/Region Code";
                                exit;
                            end;
                        end;
                    end;
                end;

                // Se não encontrou no Posted, tentar o Warehouse Shipment (ainda não enviado)
                WhseShipmentLine.SetRange("No.", "Whse. Shipment No.");
                if WhseShipmentLine.FindFirst() then begin
                    if (WhseShipmentLine."Source Type" = Database::"Sales Line") and
                       (WhseShipmentLine."Source Subtype" = 1) then begin
                        if SalesHeader.Get(SalesHeader."Document Type"::Order, WhseShipmentLine."Source No.") then begin
                            if Customer.Get(SalesHeader."Sell-to Customer No.") then begin
                                CustomerName := Customer.Name;
                                CustomerAddress := Customer.Address;
                                CustomerCity := Customer.City;
                                CustomerPostCode := Customer."Post Code";
                                CustomerCountry := Customer."Country/Region Code";
                            end;
                        end;
                    end;
                end;
            end;
        }
    }

    rendering
    {
        layout(wordLayout)
        {
            Type = Word;
            LayoutFile = 'BoxShippingLabel.docx';
        }
    }

    var
        CustomerName: Text[100];
        CustomerAddress: Text[100];
        CustomerCity: Text[30];
        CustomerPostCode: Code[20];
        CustomerCountry: Code[10];
}