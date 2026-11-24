// defines whether the journal line registers or cancels a seminar participant.
enum 50135 "CSD Seminar Journal Entry Type"
{
    Extensible = true;

    value(0; Registration)
    {
        Caption = 'Registration';
    }
    value(1; Cancellation)
    {
        Caption = 'Cancellation';
    }
}

// identifies which seminar-related cost or charge the journal line represents.
enum 50136 "Seminar Journal Charge Type"
{
    Extensible = true;

    value(0; Instructor)
    {
        Caption = 'Instructor';
    }
    value(1; Room)
    {
        Caption = 'Room';
    }
    value(2; Participant)
    {
        Caption = 'Participant';
    }
}

// specifies the source type used to calculate a seminar charge.
enum 50137 "CSD Seminar Charge Type"
{
    Extensible = true;

    value(0; Resource)
    {
        Caption = 'Resource';
    }
    value(1; "G/L Account")
    {
        Caption = 'G/L Account';
    }
}

// specifies the record type from which the journal line originated.
enum 50138 "Seminar Journal Source Type"
{
    Extensible = true;

    value(0; Seminar)
    {
        Caption = 'Seminar';
    }
}
