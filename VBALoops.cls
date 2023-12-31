Option Explicit

Sub stocks()

Dim ticker As String
Dim year_start As Double
Dim year_end As Double
Dim pct_change As Double
Dim total_volume As LongLong
Dim yearly_change As Double
Dim i As LongLong
Dim j As Integer
Dim last_row As LongLong
Dim greatest_increase As Double
Dim greatest_decrease As Double
Dim greatest_volume As LongLong
Dim greatest_increase_ticker As String
Dim greatest_decrease_ticker As String
Dim greatest_volume_ticker As String
Dim ws As Worksheet

'loop through each sheet in workbook
For Each ws In ThisWorkbook.Sheets
ws.Activate
    
    'set labels
    Cells(1, 10).Value = "Ticker"
    Cells(1, 11).Value = "Yearly Change"
    Cells(1, 12).Value = "Percent Change"
    Cells(1, 13).Value = "Total Stock Volume"
    
    'initialize variables to hold greatest increase, decrease and volume
    greatest_increase = 0
    greatest_decrease = 0
    greatest_volume = 0
    
    'initialize counters to start at second row
    j = 2
    i = 2
    
    last_row = ActiveSheet.Cells(Rows.Count, 1).End(xlUp).Row
    
    Do While i <= last_row
        'determine if date is either first or last of year
        If Right(Cells(i, 2).Value, 4) = "0102" Then
            year_start = Cells(i, 3).Value
        ElseIf Right(Cells(i, 2).Value, 4) = "1231" Then
            year_end = Cells(i, 6).Value
        End If
        
        'get ticker and add volume to running total
        ticker = Cells(i, 1).Value
        total_volume = total_volume + Cells(i, 7).Value
        
        'check if next row is a new ticker symbol.
        'if so, we are done processing one year data for current ticker value
        'we need to calculate summary values and format cells appropriately
        'then increment counter for summary range for next ticker
        If Cells(i + 1, 1).Value <> ticker Then
            Cells(j, 10).Value = ticker
            Cells(j, 11).Value = year_end - year_start
            
            If Cells(j, 11).Value < 0 Then
                Cells(j, 11).Interior.ColorIndex = 3
            Else: Cells(j, 11).Interior.ColorIndex = 4
            End If
            pct_change = (year_end - year_start) / year_start
            Cells(j, 12).Value = pct_change
            Cells(j, 12).NumberFormat = "0.00%"
            Cells(j, 13).Value = total_volume
            j = j + 1
            
            'Check if current summary values for just processed ticker
            'exceed previously calculated max values. If yes, set new max
            If pct_change > greatest_increase Then
                greatest_increase = pct_change
                greatest_increase_ticker = ticker
            End If
        
            If pct_change < greatest_decrease Then
                greatest_decrease = pct_change
                greatest_decrease_ticker = ticker
            End If
        
            If total_volume > greatest_volume Then
                greatest_volume = total_volume
                greatest_volume_ticker = ticker
            End If
            
            'reset running total to calculate volume for next ticker
            total_volume = 0
        End If
        
    i = i + 1
    Loop
    
    'write labels and values for max values
    Cells(2, 16).Value = "Greatest % Increase"
    Cells(2, 17).Value = greatest_increase_ticker
    Cells(2, 18).Value = greatest_increase
    Cells(2, 18).NumberFormat = "0.00%"

    Cells(3, 16).Value = "Greatest % Decrease"
    Cells(3, 17).Value = greatest_decrease_ticker
    Cells(3, 18).Value = greatest_decrease
    Cells(3, 18).NumberFormat = "0.00%"

    Cells(4, 16).Value = "Greatest Total Volume"
    Cells(4, 17).Value = greatest_volume_ticker
    Cells(4, 18).Value = greatest_volume

    ' Formatting the cell to handle large numbers with a comma separator
Cells(4, 18).NumberFormat = "#,##0"

    Cells(1, 17).Value = "Ticker"
    Cells(1, 18).Value = "Value"

Next ws



End Sub