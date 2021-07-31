page 50108 "Auto Reservation FactBox"
{
    Caption = 'Reservations';
    PageType = ListPart;
    SourceTable = "Auto Reservation";
    SourceTableView = sorting("Car No.", "Reserved From");
    Editable = false;


    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Reserved From"; Rec."Reserved From")
                {
                    ApplicationArea = All;
                }
                field("Reserved To"; Rec."Reserved To")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    trigger OnOpenPage()
    begin
        Rec.SetFilter("Reserved From", '>%1', CurrentDateTime);
    end;
}