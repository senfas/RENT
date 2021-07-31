page 50121 "Auto Rent Demage FactBox"
{
    Caption = 'Auto Rent Demage';
    PageType = ListPart;
    SourceTable = "Auto Rent Demage";
    SourceTableView = sorting("Demage Date", Description);
    Editable = false;


    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Demage Date"; Rec."Demage Date")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }

            }
        }
    }
}