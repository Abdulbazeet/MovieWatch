# TODO Checklist

## Core Features

- [ ] Build Watchlist screen UI (list of saved items) in `lib/presentation/watchlist/watchlist.dart`.
- [ ] Wire Watchlist screen to Supabase watch list data using existing operations + notifier.
- [ ] Remove Anime/Kdrama tabs and screens; keep only Movies + TV Shows in the main navigation.
- [ ] Add "My Lists" section for Favourites / Seen / Watchlist with filters (Movie/TV).

## Details Pages

- [ ] Add trailers section for movies (and TV) in `lib/presentation/details/details.dart` and `lib/presentation/series_details/tvshow_screen.dart`.
- [ ] Add reviews section on details screens.
- [ ] Add streaming providers/where-to-watch on details screens.
- [ ] Add "Similar / Recommended" section on details screens.

## Search & Discovery

- [ ] Add filter chips (year, genre, rating, media type) in `lib/presentation/search/search.dart`.
- [ ] Add sort options (popular, rating, latest).
- [ ] Add recent searches and suggestions.
- [ ] Implement voice search (mic icon action) if desired.

## Profile & Settings

- [ ] Make Profile menu items functional in `lib/presentation/profile/profile.dart`.
- [ ] Add theme toggle (light/dark).
- [ ] Add notification preferences (new releases, episodes).

## Offline & Performance

- [ ] Add local caching for posters/details for faster loads/offline.
- [ ] Add "Saved for offline" section in Watchlist/My Lists.
- [ ] Add skeleton loaders or shimmer to more lists where needed.

## Tests

- [ ] Add unit tests for notifiers (favourites, watchlist, seen).
- [ ] Add widget tests for search and details screens.

## Cleanup

- [ ] Remove unused/duplicate models if any (e.g., duplicate movie/series model folders).
- [ ] Document setup in `README.md` (env vars, Supabase, TMDB).
