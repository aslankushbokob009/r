<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>♔ Премиум шахматы · БЭМ + SOLID</title>
    <style>
        /* ========== ГЛОБАЛЬНЫЕ ПЕРЕМЕННЫЕ ========== */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        :root {
            --primary-dark: #2e241f;
            --primary-gold: #c8a95f;
            --primary-light: #efebd7;
            --board-light: #f3edd8;
            --board-dark: #7d5d4b;
            --highlight-lime: #b5d67c;
            --selected-gold: #f5d742;
            --wood-light: #b48b5a;
            --wood-dark: #5e3e2b;
            --shadow-heavy: 0 20px 35px -8px rgba(0,0,0,0.7), 0 0 0 2px #4f3a27 inset;
            --shadow-soft: 0 10px 25px -5px rgba(0,0,0,0.5);
            --font-serif: 'Garamond', 'Times New Roman', serif;
        }

        body {
            background: radial-gradient(circle at 30% 30%, #3b5e3e, #1d3b21);
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            font-family: var(--font-serif);
            padding: 24px;
            position: relative;
            overflow-x: hidden;
        }

        /* декоративный фон */
        body::before {
            content: "♜♞♝♚♛♟♔♕♗♘♙";
            position: absolute;
            font-size: 140px;
            opacity: 0.03;
            white-space: nowrap;
            transform: rotate(-15deg) scale(1.8);
            bottom: 0;
            left: -50px;
            color: #ffffff;
            pointer-events: none;
            letter-spacing: 30px;
        }

        /* ========== БЛОК BOARD — роскошная доска ========== */
        .board {
            background: #362712; /* тёмное дерево */
            padding: 35px 35px 30px;
            border-radius: 75px 75px 60px 60px;
            box-shadow: 
                0 35px 45px -15px #000000cc,
                0 0 0 8px #aa8e62,
                0 0 0 12px #5f4a30;
            position: relative;
            z-index: 10;
            border: 2px solid #e9c891;
        }

        /* тиснение на деревянной рамке */
        .board::after {
            content: "";
            position: absolute;
            top: 20px; left: 25px; right: 25px; bottom: 20px;
            border: 2px dashed #b4945a60;
            border-radius: 55px;
            pointer-events: none;
        }

        /* сетка доски */
        .board__grid {
            display: grid;
            grid-template-columns: repeat(8, 82px);
            grid-template-rows: repeat(8, 82px);
            border: 5px solid #4f3f2e;
            border-radius: 20px;
            overflow: hidden;
            box-shadow: inset 0 0 0 2px #ffe5b4, 0 15px 15px rgba(0,0,0,0.4);
        }

        /* ячейки */
        .board__cell {
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 54px;
            cursor: pointer;
            transition: all 0.15s cubic-bezier(0.2, 0.9, 0.3, 1.3);
            text-shadow: 2px 2px 3px rgba(0,0,0,0.3);
            position: relative;
        }

        /* классические цвета клеток */
        .board__cell_color_white {
            background-color: var(--board-light);
            background-image: radial-gradient(circle at 30% 30%, #fff8e7, #eeddbb);
        }
        .board__cell_color_black {
            background-color: var(--board-dark);
            background-image: radial-gradient(circle at 70% 70%, #946b51, #5d3f2f);
        }

        /* выделение выбранной фигуры */
        .board__cell_selected {
            box-shadow: inset 0 0 0 5px var(--selected-gold), 0 0 15px 3px #ffdb7c;
            transform: scale(1.03);
            z-index: 10;
        }

        /* подсветка возможных ходов */
        .board__cell_highlight {
            background-color: var(--highlight-lime) !important;
            background-image: radial-gradient(circle at 50% 50%, #d3f097, #8fb55a) !important;
            box-shadow: inset 0 0 0 3px #2f7d2f, 0 0 12px #b3ff8b;
            transform: scale(1.02);
        }

        /* дополнительный блеск для фигур */
        .board__cell::before {
            content: "";
            position: absolute;
            top: 2px; left: 2px; right: 2px; bottom: 2px;
            border-radius: 50%;
            background: radial-gradient(circle at 30% 30%, rgba(255,255,240,0.2), transparent 70%);
            pointer-events: none;
        }

        /* ========== БЛОК СТАТУСА (роскошная панель) ========== */
        .status {
            margin-top: 30px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            background: #2e2419;
            background: linear-gradient(165deg, #33291e, #1f1610);
            padding: 18px 35px;
            border-radius: 60px;
            border: 2px solid #b5915a;
            box-shadow: 0 10px 0 #0f0a07, inset 0 2px 8px #efd49e60;
            color: #f0e1c0;
        }

        .status__turn {
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .status__turn-icon {
            font-size: 38px;
            line-height: 1;
            filter: drop-shadow(0 3px 2px #00000070);
        }

        .status__message {
            font-size: 1.9rem;
            font-weight: 700;
            letter-spacing: 2px;
            text-transform: uppercase;
            text-shadow: 0 3px 0 #533e28;
            font-family: 'Georgia', serif;
        }

        .status__reset-btn {
            background: #c9a458;
            background: linear-gradient(180deg, #f5d58c, #aa823e);
            border: none;
            border-radius: 50px;
            padding: 12px 40px;
            font-size: 1.5rem;
            font-weight: bold;
            color: #2b1f12;
            cursor: pointer;
            transition: 0.15s;
            box-shadow: 0 8px 0 #785f34, 0 4px 12px gold;
            border: 1px solid #ffdcaa;
            text-transform: uppercase;
            letter-spacing: 2px;
            font-family: var(--font-serif);
        }

        .status__reset-btn:hover {
            background: #f5dfa5;
            transform: translateY(-3px);
            box-shadow: 0 11px 0 #785f34, 0 6px 18px #ffeeaa;
        }

        .status__reset-btn:active {
            transform: translateY(6px);
            box-shadow: 0 2px 0 #785f34;
        }

        /* ========== БЛОК ИНФО (доп. элегантность) ========== */
        .info-panel {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 22px;
            padding: 0 15px;
            color: #efdfb2;
            font-size: 1.3rem;
            text-shadow: 0 2px 5px #0e0a06;
        }

        .info-panel__notation {
            display: flex;
            gap: 30px;
        }

        .info-panel__badge {
            background: #3a2e23;
            padding: 5px 20px;
            border-radius: 40px;
            border: 1px solid #b79962;
            font-weight: 600;
            font-size: 1.2rem;
            box-shadow: inset 0 1px 4px #dbb471;
        }

        .info-panel__badge span {
            color: #fadf96;
            margin-left: 8px;
            font-size: 1.8rem;
        }

        /* ========== ФУТЕР С ДЕКОРОМ ========== */
        .footer {
            margin-top: 25px;
            text-align: center;
            font-size: 1.1rem;
            color: #d2b48c;
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 18px;
            text-shadow: 0 2px 3px black;
        }

        .footer__ornament {
            font-size: 1.7rem;
            opacity: 0.7;
            letter-spacing: 8px;
        }

        /* ========== АДАПТАЦИЯ ДЛЯ МАЛЕНЬКИХ ЭКРАНОВ ========== */
        @media (max-width: 800px) {
            .board__grid {
                grid-template-columns: repeat(8, 60px);
                grid-template-rows: repeat(8, 60px);
            }
            .board__cell {
                font-size: 40px;
            }
            .status__message {
                font-size: 1.4rem;
            }
            .status__reset-btn {
                padding: 8px 25px;
                font-size: 1.2rem;
            }
        }
    </style>
</head>
<body>
    <!-- Роскошный блок доски -->
    <div class="board">

        <!-- Декоративные элементы над доской -->
        <div class="info-panel">
            <div class="info-panel__notation">
                <span>♔</span><span>♕</span><span>♗</span><span>♘</span>
            </div>
            <div class="info-panel__badge">
                CLASSIC <span>♜</span>
            </div>
        </div>

        <!-- Шахматная сетка (заполняется через JS) -->
        <div class="board__grid" id="chess-grid"></div>

        <!-- Панель статуса с турнирным стилем -->
        <div class="status">
            <div class="status__turn">
                <span class="status__turn-icon" id="turn-icon">♔</span>
                <span class="status__message" id="turn-indicator">Ход белых</span>
            </div>
            <button class="status__reset-btn" id="reset-game">⟲ Новая игра</button>
        </div>

        <!-- Нижний декоративный элемент -->
        <div class="footer">
            <span class="footer__ornament">⚜️</span>
            <span>БЭМ · SOLID · ООП</span>
            <span class="footer__ornament">⚜️</span>
        </div>
    </div>

    <script>
        // ==================== ООП, SOLID, имитация БЭМ в JS ====================
        // Принципы SOLID отмечены комментариями в коде.

        /**
         *  S (Single Responsibility) — каждый класс отвечает за одну часть логики.
         *  O (Open/Closed) — классы открыты для расширения (например, новые фигуры через наследование).
         *  L (Liskov Substitution) — наследники (пешка, ладья) могут заменить базовый класс Figure.
         *  I (Interface Segregation) — методы не перегружены, только необходимые (getLegalMoves, символика).
         *  D (Dependency Inversion) — высокоуровневый Game зависит от абстракции Figure, а не от конкретных фигур.
         */

        // ---- Абстрактный класс Figure (Базовый для всех фигур) ----
        class Figure {
            constructor(color, row, col) {
                if (new.target === Figure) {
                    throw new Error('Нельзя создать экземпляр абстрактного класса Figure');
                }
                this.color = color;       // 'white' или 'black'
                this.row = row;
                this.col = col;
            }

            // абстрактный метод — должен быть переопределён
            getLegalMoves(boardPieces) {
                throw new Error('Метод getLegalMoves должен быть реализован');
            }

            // символ для отображения (БЭМ-уровень представления)
            getSymbol() {
                throw new Error('Метод getSymbol должен быть реализован');
            }
        }

        // ---- Конкретные фигуры (наследники Figure) ----

        class Pawn extends Figure {
            getLegalMoves(boardPieces) {
                const moves = [];
                const direction = this.color === 'white' ? -1 : 1;
                const startRow = this.color === 'white' ? 6 : 1;

                // ход на 1 клетку
                if (this.isInsideBoard(this.row + direction, this.col) && !boardPieces[this.row + direction][this.col]) {
                    moves.push({ row: this.row + direction, col: this.col });
                }
                // первый ход на 2 клетки
                if (this.row === startRow) {
                    const midRow = this.row + direction;
                    const targetRow = this.row + 2 * direction;
                    if (!boardPieces[midRow][this.col] && !boardPieces[targetRow][this.col]) {
                        moves.push({ row: targetRow, col: this.col });
                    }
                }
                // взятие (диагонали)
                for (const dcol of [-1, 1]) {
                    const newCol = this.col + dcol;
                    if (this.isInsideBoard(this.row + direction, newCol)) {
                        const target = boardPieces[this.row + direction][newCol];
                        if (target && target.color !== this.color) {
                            moves.push({ row: this.row + direction, col: newCol });
                        }
                    }
                }
                return moves;
            }

            getSymbol() {
                return this.color === 'white' ? '♙' : '♟';
            }

            isInsideBoard(r, c) {
                return r >= 0 && r < 8 && c >= 0 && c < 8;
            }
        }

        class Rook extends Figure {
            getLegalMoves(boardPieces) {
                return this.getSlidingMoves(boardPieces, [[1,0],[-1,0],[0,1],[0,-1]]);
            }

            getSymbol() {
                return this.color === 'white' ? '♖' : '♜';
            }

            getSlidingMoves(boardPieces, directions) {
                const moves = [];
                for (const [dr, dc] of directions) {
                    let r = this.row + dr, c = this.col + dc;
                    while (r >= 0 && r < 8 && c >= 0 && c < 8) {
                        if (!boardPieces[r][c]) {
                            moves.push({ row: r, col: c });
                        } else {
                            if (boardPieces[r][c].color !== this.color) moves.push({ row: r, col: c });
                            break;
                        }
                        r += dr;
                        c += dc;
                    }
                }
                return moves;
            }
        }

        class Knight extends Figure {
            getLegalMoves(boardPieces) {
                const jumps = [[2,1],[2,-1],[-2,1],[-2,-1],[1,2],[1,-2],[-1,2],[-1,-2]];
                const moves = [];
                for (const [dr, dc] of jumps) {
                    const r = this.row + dr, c = this.col + dc;
                    if (r >= 0 && r < 8 && c >= 0 && c < 8) {
                        if (!boardPieces[r][c] || boardPieces[r][c].color !== this.color) {
                            moves.push({ row: r, col: c });
                        }
                    }
                }
                return moves;
            }

            getSymbol() {
                return this.color === 'white' ? '♘' : '♞';
            }
        }

        class Bishop extends Figure {
            getLegalMoves(boardPieces) {
                return this.getSlidingMoves(boardPieces, [[1,1],[1,-1],[-1,1],[-1,-1]]);
            }

            getSymbol() {
                return this.color === 'white' ? '♗' : '♝';
            }

            getSlidingMoves(boardPieces, directions) {
                const moves = [];
                for (const [dr, dc] of directions) {
                    let r = this.row + dr, c = this.col + dc;
                    while (r >= 0 && r < 8 && c >= 0 && c < 8) {
                        if (!boardPieces[r][c]) {
                            moves.push({ row: r, col: c });
                        } else {
                            if (boardPieces[r][c].color !== this.color) moves.push({ row: r, col: c });
                            break;
                        }
                        r += dr;
                        c += dc;
                    }
                }
                return moves;
            }
        }

        class Queen extends Figure {
            getLegalMoves(boardPieces) {
                const rookDirs = [[1,0],[-1,0],[0,1],[0,-1]];
                const bishopDirs = [[1,1],[1,-1],[-1,1],[-1,-1]];
                const allDirs = rookDirs.concat(bishopDirs);
                const moves = [];
                for (const [dr, dc] of allDirs) {
                    let r = this.row + dr, c = this.col + dc;
                    while (r >= 0 && r < 8 && c >= 0 && c < 8) {
                        if (!boardPieces[r][c]) {
                            moves.push({ row: r, col: c });
                        } else {
                            if (boardPieces[r][c].color !== this.color) moves.push({ row: r, col: c });
                            break;
                        }
                        r += dr;
                        c += dc;
                    }
                }
                return moves;
            }

            getSymbol() {
                return this.color === 'white' ? '♕' : '♛';
            }
        }

        class King extends Figure {
            getLegalMoves(boardPieces) {
                const steps = [[1,0],[-1,0],[0,1],[0,-1],[1,1],[1,-1],[-1,1],[-1,-1]];
                const moves = [];
                for (const [dr, dc] of steps) {
                    const r = this.row + dr, c = this.col + dc;
                    if (r >= 0 && r < 8 && c >= 0 && c < 8) {
                        if (!boardPieces[r][c] || boardPieces[r][c].color !== this.color) {
                            moves.push({ row: r, col: c });
                        }
                    }
                }
                return moves;
            }

            getSymbol() {
                return this.color === 'white' ? '♔' : '♚';
            }
        }

        // ==================== Игровое состояние (Single Responsibility) ====================
        class GameState {
            constructor() {
                this.board = this.createInitialBoard(); // 8x8 массив (null или фигура)
                this.currentTurn = 'white';
                this.selectedRow = null;
                this.selectedCol = null;
                this.highlightedMoves = []; // {row, col}
            }

            createInitialBoard() {
                // пустая доска 8x8
                const b = Array(8).fill().map(() => Array(8).fill(null));

                // чёрные фигуры (индекс 7 — последняя горизонталь)
                b[0][0] = new Rook('black',0,0); b[0][7] = new Rook('black',0,7);
                b[0][1] = new Knight('black',0,1); b[0][6] = new Knight('black',0,6);
                b[0][2] = new Bishop('black',0,2); b[0][5] = new Bishop('black',0,5);
                b[0][3] = new Queen('black',0,3); b[0][4] = new King('black',0,4);
                for (let c = 0; c < 8; c++) b[1][c] = new Pawn('black',1,c);

                // белые фигуры
                b[7][0] = new Rook('white',7,0); b[7][7] = new Rook('white',7,7);
                b[7][1] = new Knight('white',7,1); b[7][6] = new Knight('white',7,6);
                b[7][2] = new Bishop('white',7,2); b[7][5] = new Bishop('white',7,5);
                b[7][3] = new Queen('white',7,3); b[7][4] = new King('white',7,4);
                for (let c = 0; c < 8; c++) b[6][c] = new Pawn('white',6,c);

                return b;
            }

            // сброс игры
            reset() {
                this.board = this.createInitialBoard();
                this.currentTurn = 'white';
                this.selectedRow = null;
                this.selectedCol = null;
                this.highlightedMoves = [];
            }

            // проверка на допустимость координат
            isValidCell(row, col) {
                return row >= 0 && row < 8 && col >= 0 && col < 8;
            }

            // переместить фигуру, обновить состояние (без проверки шах/мат для простоты, но принцип открыт)
            movePiece(fromRow, fromCol, toRow, toCol) {
                const figure = this.board[fromRow][fromCol];
                if (!figure) return false;
                if (figure.color !== this.currentTurn) return false;

                // проверка, что ход есть в highlightedMoves
                const moveValid = this.highlightedMoves.some(m => m.row === toRow && m.col === toCol);
                if (!moveValid) return false;

                // выполняем перемещение
                this.board[toRow][toCol] = figure;
                this.board[fromRow][fromCol] = null;
                figure.row = toRow;
                figure.col = toCol;

                // смена игрока
                this.currentTurn = this.currentTurn === 'white' ? 'black' : 'white';
                this.selectedRow = null;
                this.selectedCol = null;
                this.highlightedMoves = [];
                return true;
            }

            // вычислить подсвеченные ходы для фигуры
            calculateHighlights(row, col) {
                const figure = this.board[row][col];
                if (!figure || figure.color !== this.currentTurn) return [];
                const rawMoves = figure.getLegalMoves(this.board);
                // (можно добавить фильтр, чтобы не подставлять короля под шах — но это расширение)
                return rawMoves;
            }
        }

        // ==================== View (отвечает только за отрисовку) ====================
        class ChessView {
            constructor(gridElement, turnElement, turnIcon, resetButton, gameState) {
                this.grid = gridElement;
                this.turnEl = turnElement;
                this.turnIcon = turnIcon;
                this.resetBtn = resetButton;
                this.state = gameState;        // композиция (Dependency inversion: зависит от абстракции GameState)
                this.onCellClick = null;        // callback для контроллера

                this.resetBtn.addEventListener('click', () => this.handleReset());
                this.render();
            }

            // отрисовка всей доски на основе gameState
            render() {
                this.grid.innerHTML = '';
                for (let r = 0; r < 8; r++) {
                    for (let c = 0; c < 8; c++) {
                        const cell = document.createElement('div');
                        cell.className = 'board__cell';
                        // модификатор цвета
                        const isLight = (r + c) % 2 === 0;
                        cell.classList.add(isLight ? 'board__cell_color_white' : 'board__cell_color_black');

                        // отметить выбранную клетку
                        if (this.state.selectedRow === r && this.state.selectedCol === c) {
                            cell.classList.add('board__cell_selected');
                        }

                        // отметить возможные ходы
                        const isHighlighted = this.state.highlightedMoves.some(m => m.row === r && m.col === c);
                        if (isHighlighted) {
                            cell.classList.add('board__cell_highlight');
                        }

                        // фигура
                        const figure = this.state.board[r][c];
                        if (figure) {
                            cell.textContent = figure.getSymbol();
                        }

                        // data-атрибуты для событий
                        cell.dataset.row = r;
                        cell.dataset.col = c;
                        cell.addEventListener('click', (event) => {
                            if (this.onCellClick) {
                                const row = parseInt(event.currentTarget.dataset.row);
                                const col = parseInt(event.currentTarget.dataset.col);
                                this.onCellClick(row, col);
                            }
                        });

                        this.grid.appendChild(cell);
                    }
                }
                // обновить индикатор хода
                const message = this.state.currentTurn === 'white' ? 'Ход белых' : 'Ход чёрных';
                this.turnEl.textContent = message;
                this.turnIcon.textContent = this.state.currentTurn === 'white' ? '♔' : '♚';
            }

            handleReset() {
                this.state.reset();
                this.render();
            }

            // привязать обработчик кликов (контроллер)
            setClickHandler(handler) {
                this.onCellClick = handler;
            }
        }

        // ==================== Контроллер (связывает View и Model) ====================
        class ChessController {
            constructor(view, state) {
                this.view = view;
                this.state = state;
                this.view.setClickHandler((row, col) => this.handleCellClick(row, col));
            }

            handleCellClick(row, col) {
                const state = this.state;

                // 1. Если уже есть выделенная фигура и есть подсвеченные ходы — пробуем сходить
                if (state.selectedRow !== null && state.selectedCol !== null && state.highlightedMoves.length > 0) {
                    const moveSuccess = state.movePiece(state.selectedRow, state.selectedCol, row, col);
                    if (moveSuccess) {
                        this.view.render();
                        return;
                    }
                }

                // 2. Иначе: выбираем другую фигуру, если она принадлежит текущему игроку
                const figure = state.board[row][col];
                if (figure && figure.color === state.currentTurn) {
                    // снять выделение с предыдущей
                    state.selectedRow = row;
                    state.selectedCol = col;
                    state.highlightedMoves = state.calculateHighlights(row, col);
                } else {
                    // клик по пустой или чужой фигуре — сброс выделения
                    state.selectedRow = null;
                    state.selectedCol = null;
                    state.highlightedMoves = [];
                }
                this.view.render();
            }
        }

        // ==================== Инициализация приложения ====================
        (function main() {
            const grid = document.getElementById('chess-grid');
            const turnIndicator = document.getElementById('turn-indicator');
            const turnIcon = document.getElementById('turn-icon');
            const resetBtn = document.getElementById('reset-game');

            const gameState = new GameState();          // модель
            const view = new ChessView(grid, turnIndicator, turnIcon, resetBtn, gameState);  // представление
            new ChessController(view, gameState);       // контроллер

            // начальный рендер (уже в конструкторе view.render())
        })();
    </script>
</body>
</html>
