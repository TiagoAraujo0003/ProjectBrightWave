report 50200 "Certificate"
{
    Caption = 'Safety Certificate';
    DefaultLayout = Word;
    WordLayout = 'Certificate.docx';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem(SafetyCertificate; "Certificate")
        {
            column(EntryNo; "Entry No.")
            {
            }
            column(SalesOrderNo; "Sales Order No.")
            {
            }
            column(CustomerNo; "Customer No.")
            {
            }
            column(CustomerName; "Customer Name")
            {
            }
            column(DateOfSale; "Date of Sale")
            {
            }
            column(ProductName; "Product Name")
            {
            }
            column(Manufacturer; "Manufacturer")
            {
            }
            column(CertificateNo; "Certificate No.")
            {
            }
            column(ValidTo; "Valid To")
            {
            }
        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Options)
                {
                    Caption = 'Options';
                }
            }
        }
    }
}