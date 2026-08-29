const GAMES = [
  {
    id: 1,
    title: "TETRIS",
    image: "assets/icons/tetris.jpeg",
    href: "games/tetris.html",
  },
  {
    id: 2,
    title: "Dragon Realm",
    image:
      "https://images.unsplash.com/photo-1560419015-7c427e8ae5ba?w=400&h=300&fit=crop",
  },
  {
    id: 3,
    title: "Space Raiders",
    image:
      "https://images.unsplash.com/photo-1446776811953-b23d57bd21aa?w=400&h=300&fit=crop",
  },
  {
    id: 4,
    title: "Neon Strike",
    image:
      "https://images.unsplash.com/photo-1550745165-9bc0b252726f?w=400&h=300&fit=crop",
  },
  {
    id: 5,
    title: "Shadow Blade",
    image:
      "https://images.unsplash.com/photo-1511882150382-421056c89033?w=400&h=300&fit=crop",
  },
  {
    id: 6,
    title: "PONG",
    image:
      "https://images.unsplash.com/photo-1493711662062-fa541adb3fc8?w=400&h=300&fit=crop",
    href: "games/pong.html",
  },
  {
    id: 7,    
    title: "Storm Forge",
    image:
      "https://images.unsplash.com/photo-1518770660439-4636190af475?w=400&h=300&fit=crop",
  },
  {
    id: 8,
    title: "Void Hunter",
    image:
      "https://images.unsplash.com/photo-1555680202-c86f0e12f086?w=400&h=300&fit=crop",
  },
  {
    id: 9,
    title: "Iron Citadel",
    image:
      "https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=400&h=300&fit=crop",
  },
  {
    id: 10,
    title: "Mech Brawler",
    image:
      "https://images.unsplash.com/photo-1531297484001-80022131f5a1?w=400&h=300&fit=crop",
  },
  {
    id: 11,
    title: "Ghost Recon",
    image:
      "https://images.unsplash.com/photo-1506318137071-a8e063b4bec0?w=400&h=300&fit=crop",
  },
  {
    id: 12,
    title: "Fire Emblem",
    image:
      "https://images.unsplash.com/photo-1469474968028-56623f02e42e?w=400&h=300&fit=crop",
  },
  {
    id: 13,
    title: "Arctic Zone",
    image:
      "https://images.unsplash.com/photo-1483347756197-71ef80e95f73?w=400&h=300&fit=crop",
  },
  {
    id: 14,
    title: "Deep Abyss",
    image:
      "https://images.unsplash.com/photo-1504701954957-2010ec3bcec1?w=400&h=300&fit=crop",
  },
  {
    id: 15,
    title: "Thunder Run",
    image:
      "https://images.unsplash.com/photo-1492571350019-22de08371fd3?w=400&h=300&fit=crop",
  },
];

const grid = document.getElementById("grid");
const empty = document.getElementById("empty");
const input = document.getElementById("search");
const clear = document.getElementById("clear");

function render(q) {
  const filtered = GAMES.filter((g) =>
    g.title.toLowerCase().includes(q.toLowerCase()),
  );
  grid.innerHTML = "";
  if (filtered.length === 0) {
    empty.style.display = "block";
    grid.style.display = "none";
  } else {
    empty.style.display = "none";
    grid.style.display = "grid";
    filtered.forEach((g) => {
      const card = g.href
        ? document.createElement("a")
        : document.createElement("div");
      card.className = "card";
      if (g.href) {
        card.href = g.href;
        card.style.textDecoration = "none";
      }
      card.innerHTML = `
                <div class="card-img">
                  <img src="${g.image}" alt="${g.title}" onerror="this.style.display='none'" />
                </div>
                <div class="card-label">${g.title}</div>
              `;
      grid.appendChild(card);
    });
  }
}

input.addEventListener("input", () => {
  const q = input.value;
  clear.style.display = q ? "block" : "none";
  render(q);
});

clear.addEventListener("click", () => {
  input.value = "";
  clear.style.display = "none";
  render("");
});

render("");
