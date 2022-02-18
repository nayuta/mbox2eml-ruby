# mbox2eml-ruby
Split mbox files to eml files.

## Usage

1. Put mbox files into the same directory as this script
2. Run script

After parsing,

- Directories named mbox file name (without extension) created under export directory `export_data`
- Parsed eml files saved named by number ordered sort in mbox file

Not processed when `export_data` directory already exists.

## Limitation

The script only searches string starts with `From` after empty line and handles the line as a new email file.

It does not follow any standards.
