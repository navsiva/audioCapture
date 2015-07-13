# Daily Field Recording

This app reminds you to open it once a day. When opened from a notification it goes directly to recording audio.

The app allows users to record one field recording per day, and uploads them to parse/cloudkit so they are backed up and available on any device the user has.

Users can tag the audio, as well as search and sort by tag.

Recordings are limited to some short length, say 5s. There will be a custom audio recording UI to make the recording with.

Some of the past field recordings should be available offline, but users should be able to perge past recordings from their device, and re-download from the cloud. Recordings older than 1 month are automatically removed from your local storage.

All recordings are location tagged if the user gives location permission.

## Views:

1. Log view: table or collection view of every recorded entry. Search bar to filter list on metadata. Has waveform thumbnails from each recording???? or maybe a photo. Log view also shows cloud upload status.
2. Recording view
4. Metadata edit view: after recording, add tags, people mentioned, notes, etc.
5. metadata view view: view metadata. share button.
5. Settings: choose when your recording reminder happens.

## Optional:

- Mark recordings as Public, they appear in a public feed. If possible get share links for tweeting them to social media.
- Map view of all my recording locations.
- Select a slice of of the recording to loop (baby granilar synth).


## Technologies:

AVFoundation, Parse or CloudKit and Core Data, Core Location, Local Notifications, Background Upload/Downloads.

---

Create a github repo for this project. Add me as a contributor, and commit often with clear + descriptive commit messages. I will be doing regular code reviews on the repo, so please keep it up to date.