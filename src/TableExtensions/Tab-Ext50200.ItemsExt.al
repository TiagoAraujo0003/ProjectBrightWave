tableextension 50200 "Items Ext" extends Item
{
    fields
    {
        field(50200; ProdCat; Text[50])
        {
        }
        field(50201; Brand; Text[50])
        {
        }
        field(50202; CertificateNo; Code[8]) //Fazer trigger para validar
        {
        }
        field(50203; CertExpireDate; Date)
        {
        }
    }
}

