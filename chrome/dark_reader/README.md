# Dark Reader + Stylus Integration

Ensures Stylus styles take precedence over Dark Reader. Dark Reader only activates on sites without custom styles.

## Update exclusion list

When new Stylus styles are added:

### 1. Extract domains from Stylus

- Open Stylus -> Manage
- Press `Cmd+Option+i` to open DevTools
- Go to Console tab
- Run:

```javascript
(async()=>{
  const styles = await API.styles.getAll();
  const d = new Set();

  styles.forEach(s=>{
    s.sections?.forEach(c=>{
      c.domains?.forEach(domain => d.add(domain));
      c.urlPrefixes?.forEach(u=>{
        try{
          d.add(new URL(u).hostname);
        } catch(e){}
      });
      c.urls?.forEach(u=>{
        try{
          d.add(new URL(u).hostname);
        } catch(e){}
      });
    });
  });

  const domains = Array.from(d).sort().join('\n');
  console.log(domains);
  console.log('\n---\nTotal domains:', d.size);
  console.log('\n---\nCopy the domains above and paste into Dark Reader');
})();
```

- Copy the domain list from console output

### 2. Update Dark Reader settings

- Dark Reader -> Settings (gear icon) -> Advanced
- Click "Export settings"
- In the exported JSON, find the `disabledFor` array
- Replace the full array contents with your domain list
- Format each domain as: `"domain.com",`
- Ensure the last entry has no trailing comma
- Save the file

### 3. Import updated settings

- Dark Reader -> Settings -> Advanced
- Click "Import settings"
- Select the modified JSON file

Done. Stylus now takes precedence over Dark Reader.
