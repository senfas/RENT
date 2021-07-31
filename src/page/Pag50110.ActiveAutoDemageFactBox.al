page 50110 "Active Auto Demage FactBox"
{
    Caption = 'Active Demage';
    PageType = ListPart;
    SourceTable = "Auto Demage";
    SourceTableView = sorting("Car No.", "Demage Date");
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
    trigger OnOpenPage()
    begin
        Rec.SetRange(Status, Rec.Status::Active);
    end;
}