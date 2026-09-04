const GAMES = [
  {
    id: 1,
    title: "TETRIS",
    image: "web/asset/thumbnails/tetris.jpeg",
    href: "web/games/tetris.html",
  },

  {
    id: 6,
    title: "PONG",
    image:"web/assets/thumbnails/pong.png",
    href: "web/games/pong.html",
  },
  {
    id: 7,
    title: "Gario",
    image:
      "web/assets/thumbnails/gario.png",
    href: "web/games/gario.html"
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
const startButton = document.getElementById("start-btn");
const loadingScreen = document.getElementById("loading-screen");
const loadingCoin = document.querySelector(".gold-coin");
let selectedGameId = null;

function updateStartButtonState() {
  const hasSelection = GAMES.some((game) => game.id === selectedGameId && game.href);
  startButton.disabled = !hasSelection;
}

function selectGame(gameId) {
  selectedGameId = gameId;
  const cards = document.querySelectorAll(".card");
  cards.forEach((card) => {
    const isSelected = Number(card.dataset.gameId) === selectedGameId;
    card.classList.toggle("is-selected", isSelected);
    card.setAttribute("aria-pressed", String(isSelected));
  });
  updateStartButtonState();
}

function render(q) {
  const filtered = GAMES.filter((g) =>
    g.title.toLowerCase().includes(q.toLowerCase()),
  );
  grid.innerHTML = "";
  if (filtered.length === 0) {
    empty.style.display = "block";
    grid.style.display = "none";
    updateStartButtonState();
    return;
  }

  empty.style.display = "none";
  grid.style.display = "grid";
  filtered.forEach((g) => {
    const card = document.createElement("button");
    card.type = "button";
    card.className = "card";
    card.dataset.gameId = String(g.id);
    card.setAttribute("aria-pressed", "false");
    card.innerHTML = `
      <div class="card-img">
        <img src="${g.image}" alt="${g.title}" onerror="this.style.display='none'" />
      </div>
      <div class="card-label">${g.title}</div>
    `;

    if (g.id === selectedGameId) {
      card.classList.add("is-selected");
      card.setAttribute("aria-pressed", "true");
    }

    card.addEventListener("click", () => {
      selectGame(g.id);
    });

    grid.appendChild(card);
  });

  updateStartButtonState();
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

startButton.addEventListener("click", () => {
  const selectedGame = GAMES.find((game) => game.id === selectedGameId && game.href);
  if (!selectedGame) {
    return;
  }

  loadingScreen.classList.remove("is-visible");
  void loadingScreen.offsetWidth;
  loadingScreen.classList.add("is-visible");
  loadingScreen.setAttribute("aria-hidden", "false");

  loadingCoin.classList.remove("coin-pop");
  void loadingCoin.offsetWidth;
  loadingCoin.classList.add("coin-pop");

  window.setTimeout(() => {
    window.location.href = selectedGame.href;
  }, 1100);
});

render("");
