import mne
from pathlib import Path

# Folder containing EDF files
data_folder = Path("data")

# Loop through all .edf files in the folder
for edf_file in data_folder.glob("*.edf"):
    print(f"Processing {edf_file.name} ...")

    # Load the EDF
    raw = mne.io.read_raw_edf(edf_file, preload=True, verbose="ERROR")

    # Remove annotations
    raw.set_annotations(None)

    # Export, overwriting the same file (no annotations)
    raw.export(
        edf_file,  # overwrite same file
        fmt="edf",
        physical_range=(-32768, 32767),  # full 16-bit range
        overwrite=True
    )

    print(f" → Saved {edf_file.name} (annotations removed)")

print("Done! ✅ All EDF files processed.")
