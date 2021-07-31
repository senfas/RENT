page 50120 "Finished License Pic. FactBox"
{
    Caption = 'Driver License';
    DeleteAllowed = false;
    InsertAllowed = false;
    LinksAllowed = false;
    PageType = CardPart;
    SourceTable = "Finished Auto Rent Header";

    layout
    {
        area(content)
        {
            field("Driver License"; Rec."Driver License")
            {
                ApplicationArea = All;
                ShowCaption = false;
            }
        }
    }
}

