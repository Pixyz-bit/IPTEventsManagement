# Local fonts

Plus Jakarta Sans (normal, variable weights 200–800) and JetBrains Mono
(normal, variable weights 100–800) are served by `../css/fonts.css`.
Latin and Latin Extended subsets support the interface text and accented names.
Only subsets needed by the displayed characters are downloaded by the browser.
`font-display: swap` keeps text visible while the local files load.

Downloaded from Google Fonts on 2026-10-07:

- https://fonts.google.com/specimen/Plus+Jakarta+Sans
- https://fonts.google.com/specimen/JetBrains+Mono

Both families use the SIL Open Font License 1.1. Their original license files
are included here and must remain with the distributed fonts.

Every standalone page and the admin master link to the local stylesheet using
`ResolveUrl`, so fonts work when deployed under an IIS virtual directory.
These assets are included as project content for publishing. Runtime font
loading does not require Google Fonts or another external font service.
