# GOAT — Vehicle Incident Logbook (CCL1-25)

SwiftUI app for logging and tracking vehicle incidents by license plate, with a built-in live plate scanner.

## Overview

GOAT is an iOS app for keeping records against vehicles — the kind of tool parking or building security staff would use. Every record ("catatan") is tied to a license plate: scan the plate with the camera or type it in, attach a photo, pick a category, and add a note. The dashboard groups vehicles by their most recent activity so the newest cases surface first, and each vehicle has a complete, filterable history. All data is stored on-device with SwiftData. The UI is in Indonesian.

## Features

- Dashboard grouped by date of last activity, with per-vehicle cards showing the plate, latest category and note, and relative time
- Live license plate scanning: the AVFoundation camera feed is processed frame-by-frame with Vision's `VNRecognizeTextRequest`; a confirmation dialog hands the detected plate to the entry form or the search field
- New-entry flow: plate (typed or scanned), vehicle type (car/motorcycle), photo from camera or photo library (PhotosPicker and `UIImagePickerController`), category, and free-text note — saving is disabled until required fields are filled
- Entries for an already-known plate are appended to that vehicle's history rather than creating a duplicate vehicle
- Vehicle detail view: entry history grouped by day, text search across categories and notes, date-range filtering, inline editing of the plate and vehicle type, and swipe-to-delete with a guard when removing a vehicle's last entry
- Dashboard search by plate number, including scan-to-search
- SwiftData models: `Car` (plate, type) with a one-to-many relationship to `Entry` (category, timestamp, note, optional image)

## Tech Stack

- Swift, SwiftUI (iOS)
- SwiftData for on-device persistence
- Vision (`VNRecognizeTextRequest`) for plate text recognition
- AVFoundation for the live camera preview and frame capture
- PhotosUI / UIKit interop for photo attachment

## Project Structure

```
CCL1-25GOAT/
  CCL1_25GOATApp.swift          App entry point + SwiftData models (Car, Entry)
  DashboardView.swift           Date-grouped vehicle list, search, vehicle-type filter
  PlateScannerView.swift        Camera preview + per-frame Vision OCR + confirm dialog
  AddNewEntryView.swift         New record form: scan, photo (camera/gallery), category, note
  VehicleDetailView.swift       Per-vehicle history with search, date filter, editing, deletion
  FilterView.swift              Date-range filter sheet
  VehicleTypeFilterView.swift   Car/motorcycle filter control
  EditPlateView.swift           Plate editing
  DeleteConfirmationView.swift  Delete confirmation dialog
  CustomSearchBar.swift         Search bar component
```

## Getting Started

1. Open `CCL1-25GOAT.xcodeproj` in Xcode.
2. Build and run. Use a physical iPhone to test the plate scanner and camera capture; the rest of the app works in the simulator.
