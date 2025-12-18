table 50200 "Certificate"
{
    Caption = 'Certificate';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            AutoIncrement = true;
            Caption = 'Entry No.';
        }
        field(2; "Sales Order No."; Code[20])
        {
            Caption = 'Sales Order No.';
            TableRelation = "Sales Header";
        }
        field(3; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            TableRelation = Customer;
        }
        field(4; "Customer Name"; Text[100])
        {
            Caption = 'Customer Name';
        }
        field(5; "Date of Sale"; Date)
        {
            Caption = 'Date of Sale';
        }
        field(6; "Product Name"; Text[100])
        {
            Caption = 'Product Name';
        }
        field(7; "Manufacturer"; Text[100])
        {
            Caption = 'Manufacturer';
        }
        field(8; "Certificate No."; Code[50])
        {
            Caption = 'Certificate No.';
        }
        field(9; "Valid To"; Date)
        {
            Caption = 'Valid To';
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }

}

