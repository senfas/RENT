page 50114 "Driver License Picture FactBox"
{
    Caption = 'Driver License';
    DeleteAllowed = false;
    InsertAllowed = false;
    LinksAllowed = false;
    PageType = CardPart;
    SourceTable = "Auto Rent Header";

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

    actions
    {
        area(processing)
        {
            action(ImportPicture)
            {
                ApplicationArea = All;
                Caption = 'Import';
                Image = Import;
                ToolTip = 'Import a picture file.';

                trigger OnAction()
                var
                    FileManagement: Codeunit "File Management";
                    FileName: Text;
                    DriverLicenseFileName: Text;
                    OverrideImageQst: Label 'The existing picture will be replaced. Do you want to continue?';
                    SelectPictureTxt: Label 'Select a picture to upload';
                    MustSpecifyNameErr: Label 'You must specify a customer name before you can import a picture.';
                begin
                    if Rec."Customer No." = '' then
                        Error(MustSpecifyNameErr);

                    if Rec."Driver License".HasValue then
                        if not Confirm(OverrideImageQst) then
                            exit;

                    FileName := FileManagement.UploadFile(SelectPictureTxt, DriverLicenseFileName);
                    if FileName = '' then
                        exit;

                    Clear(Rec."Driver License");
                    Rec."Driver License".ImportFile(FileName, DriverLicenseFileName);
                    if not Rec.Modify(true) then
                        Rec.Insert(true);
                end;
            }
            action(DeletePicture)
            {
                ApplicationArea = All;
                Caption = 'Delete';
                Enabled = DeleteExportEnabled;
                Image = Delete;
                ToolTip = 'Delete the record.';

                trigger OnAction()
                Var
                    DeleteImageQst: Label 'Are you sure you want to delete the picture?';
                begin
                    if not Confirm(DeleteImageQst) then
                        exit;

                    Clear(Rec."Driver License");
                    Rec.Modify(true);
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        SetEditableOnPictureActions;
    end;

    var
        DeleteExportEnabled: Boolean;

    local procedure SetEditableOnPictureActions()
    begin
        DeleteExportEnabled := Rec."Driver License".HasValue;
    end;
}

