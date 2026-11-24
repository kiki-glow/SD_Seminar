/// <summary>
    /// Stores an audit summary for one seminar posting run.
    /// The register links the posting source, batch, user, and the range of ledger entries created together.
/// </summary> 
table 50133 "CSD Seminar Register"
{
    Caption = 'Seminar Register';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "No."; Integer)
        {
            Caption = 'No.';
            DataClassification = CustomerContent;
            // uniquely identifies this posting register.
            // the posting process assigns a new number so that the generated ledger-entry range can be traced later.
        }
        field(2; "From Entry No."; Integer)
        {
            Caption = 'From Entry No.';
            DataClassification = CustomerContent;
            // marks the first Seminar Ledger Entry created by this posting run.
            // together with To Entry No., this defines the complete entry range created by the same operation.
            TableRelation = "CSD Seminar Ledger Entry";
        }
        field(3; "To Entry No."; Integer)
        {
            Caption = 'To Entry No.';
            DataClassification = CustomerContent;
            // marks the last Seminar Ledger Entry created by this posting run.
            // users can use the From and To entry numbers to review every ledger entry in the posting batch.
            TableRelation = "CSD Seminar Ledger Entry";
        }
        field(4; "Creation Date"; Date)
        {
            Caption = 'Creation Date';
            DataClassification = CustomerContent;
            // records the work date on which the posting register was created.
            // this makes it possible to find and audit posting runs by date.
        }
        field(5; "Source Code"; Code[10])
        {
            Caption = 'Source Code';
            DataClassification = CustomerContent;
            TableRelation = "Source Code";
            // identifies the application feature that created the ledger entries.
            // the value is supplied from Source Code Setup to keep the posting audit trail consistent with Business Central.
        }
        field(6; "User ID"; Code[50])
        {
            Caption = 'User ID';
            DataClassification = CustomerContent;
            TableRelation = User."User Name";
            ValidateTableRelation = false;
            // records the user who created the posting register.
            // validation is disabled because the user table can contain user names that are not available in the default lookup filter.

            trigger OnLookup()
            var
                SelectedUser: Record User;
                UserSelection: Codeunit "User Selection";
            begin
                // opens the supported Business Central user lookup and stores the selected user name.
                if UserSelection.Open(SelectedUser) then
                    "User ID" := SelectedUser."User Name";
            end;
        }
        field(7; "Journal Batch Name"; Code[20])
        {
            Caption = 'Journal Batch Name';
            DataClassification = CustomerContent;
            // identifies the seminar journal batch that produced this register.
            // combined with Source Code and Creation Date, it helps locate the original posting run.
        }
    }
    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
        key(Index02; "Creation Date") { }
        // supports finding registers created from a specific source code and journal batch on a given date.
        key(Index03; "Source Code", "Journal Batch Name", "Creation Date") { }
    }

}
