# Render Markdown Test File

This file demonstrates all features of the render-markdown.nvim plugin.

## Headings

All heading levels are supported with custom icons:

# Heading 1
## Heading 2
### Heading 3
#### Heading 4
##### Heading 5
###### Heading 6

---

## Text Formatting

**Bold text** using double asterisks or __double underscores__.

*Italic text* using single asterisks or _single underscores_.

***Bold and italic*** using triple asterisks.

~~Strikethrough~~ using double tildes.

`Inline code` with backticks for syntax highlighting.

---

## Lists

### Unordered Lists (Bullets)

- First level item
- Another first level item
  - Second level item
  - Another second level
    - Third level item
    - More third level
      - Fourth level item

### Ordered Lists

1. First item
2. Second item
3. Third item
   1. Nested ordered item
   2. Another nested item
4. Back to first level

### Task Lists (Checkboxes)

- [ ] Unchecked task
- [x] Completed task
- [ ] Another pending task
  - [x] Nested completed subtask
  - [ ] Nested pending subtask

---

## Code Blocks

### Inline Code

Here's some `inline code` in a sentence.

### Fenced Code Blocks

```lua
-- Lua code example
local function greet(name)
    print("Hello, " .. name .. "!")
end

greet("World")
```

```python
# Python code example
def fibonacci(n):
    if n <= 1:
        return n
    return fibonacci(n-1) + fibonacci(n-2)

print(fibonacci(10))
```

```javascript
// JavaScript code example
const factorial = (n) => {
    return n <= 1 ? 1 : n * factorial(n - 1);
};

console.log(factorial(5));
```

```bash
# Bash script example
#!/bin/bash
echo "Current directory: $(pwd)"
ls -la
```

---

## Block Quotes

> This is a block quote.
> It can span multiple lines.
>
> And have multiple paragraphs.

> Nested quotes work too:
> > This is nested inside
> > > And this is even deeper

---

## Links and URLs

[GitHub](https://github.com) - external link

[Relative link](./README.md) - local file

[Reference link][ref] - reference style

[ref]: https://example.com "Reference title"

Auto-link: <https://example.com>

---

## Tables

| Feature | Status | Priority |
|---------|--------|----------|
| Headings | ✅ Done | High |
| Code blocks | ✅ Done | High |
| Tables | ✅ Done | Medium |
| Callouts | 🔄 Testing | Medium |

### Aligned Tables

| Left aligned | Center aligned | Right aligned |
|:-------------|:--------------:|--------------:|
| Left         | Center         | Right         |
| Text         | More text      | Numbers: 123  |

---

## Callouts (GitHub Style)

> [!NOTE]
> This is a note callout.
> Use it for highlighting important information.

> [!TIP]
> This is a tip callout.
> Helpful hints and suggestions go here.

> [!IMPORTANT]
> This is an important callout.
> Critical information that needs attention.

> [!WARNING]
> This is a warning callout.
> Potential issues or things to watch out for.

> [!CAUTION]
> This is a caution callout.
> Dangerous actions or critical warnings.

---

## Horizontal Rules

Three or more hyphens, asterisks, or underscores:

---

***

___

---

## Complex Nesting

1. First ordered item
   - Unordered subitem
   - Another subitem
     - [x] Completed nested task
     - [ ] Pending nested task
       > A quote inside a task list!
       >
       > With multiple lines.

2. Second ordered item
   ```lua
   -- Code block in a list
   local x = 42
   ```

3. Third ordered item
   | Column A | Column B |
   |----------|----------|
   | Data 1   | Data 2   |

---

## Images (Syntax Demo)

![Alt text](path/to/image.png "Image title")

![External image](https://via.placeholder.com/150)

---

## Footnotes

Here's a sentence with a footnote.[^1]

Another sentence with another footnote.[^2]

[^1]: This is the first footnote.
[^2]: This is the second footnote with more details.

---

## Definition Lists

Term 1
: Definition 1
: Alternative definition

Term 2
: Definition for term 2

---

## LaTeX Math

**Note:** Requires either `latex2text` (pylatexenc) or `utftex` to be installed and in PATH. Try both to see which one you prefer.

### Inline Math

Einstein's famous equation: $E = mc^2$

Pythagorean theorem: $a^2 + b^2 = c^2$

Greek letters: $\alpha, \beta, \gamma, \Delta, \Omega$

Subscripts and superscripts: $x_1, x_2, x^2, x^{2n}$

### Block Math

Quadratic formula:
$$
x = \frac{-b \pm \sqrt{b^2 - 4ac}}{2a}
$$

Integral:
$$
\int_0^\infty e^{-x^2} dx = \frac{\sqrt{\pi}}{2}
$$

Summation:
$$
\sum_{i=1}^{n} i = \frac{n(n+1)}{2}
$$

Matrix:
$$
\begin{pmatrix}
a & b\\
c & d
\end{pmatrix}
$$

Limits:
$$
\lim_{x \to \infty} \frac{1}{x} = 0
$$

Fractions and nested expressions:
$$
\frac{d}{dx}\left(\frac{x^2 + 1}{x - 1}\right)
$$

Set notation:
$$
\mathbb{R}, \mathbb{N}, \mathbb{Z}, \mathbb{Q}, \mathbb{C}
$$

Logical operators:
$$
\forall x \in \mathbb{R}, \exists y \in \mathbb{R}: x < y
$$

Calculus:
$$
\nabla \cdot \mathbf{F} = \frac{\partial F_x}{\partial x} + \frac{\partial F_y}{\partial y} + \frac{\partial F_z}{\partial z}
$$

---

## Mixed Content Example

### Project TODO List

> [!IMPORTANT]
> Complete these tasks before the deadline!

- [x] Set up development environment
  ```bash
  npm install
  npm run dev
  ```

- [ ] Implement core features
  - [x] User authentication
  - [ ] API integration
  - [ ] Error handling

- [ ] Write documentation
  | Section | Status |
  |---------|--------|
  | Setup   | ✅     |
  | API     | 🔄     |
  | Deploy  | ❌     |

> [!TIP]
> Use `git commit -m "message"` for atomic commits.

---

## HTML in Markdown (Raw)

<div align="center">
  <strong>HTML works too!</strong>
</div>

<details>
<summary>Click to expand</summary>

Hidden content inside collapsible section.

</details>

---

## Escape Characters

Use backslash to escape markdown syntax:

\*Not italic\*
\[Not a link\]
\`Not code\`

---

## Special Characters & Emoji

Markdown supports emoji: 🚀 ✨ 🎉 📝 ✅ ❌ 🔥

Special characters: © ® ™ § ¶ † ‡ • …

---

## End of Test File

This file covers all major markdown rendering features supported by render-markdown.nvim.
Test by opening in Neovim with the plugin configured!
