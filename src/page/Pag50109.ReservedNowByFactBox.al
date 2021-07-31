page 50109 "Reserved Now By FactBox"
{
    Caption = 'Reserved Now By';
    PageType = ListPart;
    SourceTable = "Auto Reservation";
    Editable = false;


    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Customer No."; Rec."Customer No.")
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
        Rec.SetFilter("Reserved To", '>%1', CurrentDateTime);
        Rec.SetFilter("Reserved From", '<%1', CurrentDateTime);
    end;
}