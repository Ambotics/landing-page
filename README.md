# pr-assets

Screenshots embedded in pull request bodies. This branch is intentionally an
orphan: it shares no history with `main` and is never merged, so the images stay
out of the source tree and out of every PR diff.

Reference them from a PR with a raw URL:

```markdown
![alt text](https://raw.githubusercontent.com/Ambotics/landing-page/pr-assets/<file>.png)
```

Name files `pr-<number>-<slug>.png`.
