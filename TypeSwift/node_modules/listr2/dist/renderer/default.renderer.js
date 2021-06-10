"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.DefaultRenderer = void 0;
const cli_truncate_1 = __importDefault(require("cli-truncate"));
const figures_1 = __importDefault(require("figures"));
const indent_string_1 = __importDefault(require("indent-string"));
const log_update_1 = __importDefault(require("log-update"));
const os_1 = require("os");
const chalk_1 = __importDefault(require("../utils/chalk"));
/** Default updating renderer for Listr2 */
class DefaultRenderer {
    constructor(tasks, options, renderHook$) {
        this.tasks = tasks;
        this.options = options;
        this.renderHook$ = renderHook$;
        this.bottomBar = {};
        this.spinner = process.platform === 'win32' && !process.env.WT_SESSION ? ['-', '\\', '|', '/'] : ['⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏'];
        this.spinnerPosition = 0;
        this.options = { ...DefaultRenderer.rendererOptions, ...this.options };
    }
    getTaskOptions(task) {
        return { ...DefaultRenderer.rendererTaskOptions, ...task.rendererTaskOptions };
    }
    isBottomBar(task) {
        const bottomBar = this.getTaskOptions(task).bottomBar;
        return typeof bottomBar === 'number' && bottomBar !== 0 || typeof bottomBar === 'boolean' && bottomBar !== false;
    }
    hasPersistentOutput(task) {
        return this.getTaskOptions(task).persistentOutput === true;
    }
    hasTimer(task) {
        return this.getTaskOptions(task).showTimer === true;
    }
    /* istanbul ignore next */
    getTaskTime(task) {
        const seconds = Math.floor(task.message.duration / 1000);
        const minutes = Math.floor(seconds / 60);
        let parsedTime;
        if (seconds === 0 && minutes === 0) {
            parsedTime = `0.${Math.floor(task.message.duration / 100)}s`;
        }
        if (seconds > 0) {
            parsedTime = `${seconds % 60}s`;
        }
        if (minutes > 0) {
            parsedTime = `${minutes}m${parsedTime}`;
        }
        return chalk_1.default.dim(`[${parsedTime}]`);
    }
    createRender(options) {
        options = {
            ...{
                tasks: true,
                bottomBar: true,
                prompt: true
            },
            ...options
        };
        const render = [];
        const renderTasks = this.multiLineRenderer(this.tasks);
        const renderBottomBar = this.renderBottomBar();
        const renderPrompt = this.renderPrompt();
        if (options.tasks && (renderTasks === null || renderTasks === void 0 ? void 0 : renderTasks.trim().length) > 0) {
            render.push(renderTasks);
        }
        if (options.bottomBar && (renderBottomBar === null || renderBottomBar === void 0 ? void 0 : renderBottomBar.trim().length) > 0) {
            render.push((render.length > 0 ? os_1.EOL : '') + renderBottomBar);
        }
        if (options.prompt && (renderPrompt === null || renderPrompt === void 0 ? void 0 : renderPrompt.trim().length) > 0) {
            render.push((render.length > 0 ? os_1.EOL : '') + renderPrompt);
        }
        return render.length > 0 ? render.join(os_1.EOL) : '';
    }
    render() {
        var _a;
        // Do not render if we are already rendering
        if (this.id) {
            return;
        }
        const updateRender = () => log_update_1.default(this.createRender());
        /* istanbul ignore if */
        if (!((_a = this.options) === null || _a === void 0 ? void 0 : _a.lazy)) {
            this.id = setInterval(() => {
                this.spinnerPosition = ++this.spinnerPosition % this.spinner.length;
                updateRender();
            }, 100);
        }
        this.renderHook$.subscribe(() => {
            updateRender();
        });
    }
    end() {
        clearInterval(this.id);
        if (this.id) {
            this.id = undefined;
        }
        // clear log updater
        log_update_1.default.clear();
        log_update_1.default.done();
        // directly write to process.stdout, since logupdate only can update the seen height of terminal
        if (!this.options.clearOutput) {
            process.stdout.write(this.createRender({ prompt: false }) + os_1.EOL);
        }
    }
    // eslint-disable-next-line
    multiLineRenderer(tasks, level = 0) {
        let output = [];
        for (const task of tasks) {
            if (task.isEnabled()) {
                // Current Task Title
                if (task.hasTitle()) {
                    if (!(tasks.some((task) => task.hasFailed()) && !task.hasFailed() && task.options.exitOnError !== false && !(task.isCompleted() || task.isSkipped()))) {
                        // if task is skipped
                        if (task.hasFailed() && this.options.collapseErrors) {
                            // current task title and skip change the title
                            output = [...output, this.formatString(task.message.error && this.options.showErrorMessage ? task.message.error : task.title, this.getSymbol(task), level)];
                        }
                        else if (task.isSkipped() && this.options.collapseSkips) {
                            // current task title and skip change the title
                            output = [
                                ...output,
                                this.formatString((task.message.skip && this.options.showSkipMessage ? task.message.skip : task.title) + (this.options.suffixSkips ? chalk_1.default.dim(' [SKIPPED]') : ''), this.getSymbol(task), level)
                            ];
                        }
                        else if (task.isCompleted() && task.hasTitle() && (this.options.showTimer || this.hasTimer(task))) {
                            // task with timer
                            output = [...output, this.formatString(`${task === null || task === void 0 ? void 0 : task.title} ${this.getTaskTime(task)}`, this.getSymbol(task), level)];
                        }
                        else {
                            // normal state
                            output = [...output, this.formatString(task.title, this.getSymbol(task), level)];
                        }
                    }
                    else {
                        // some sibling task but self has failed and this has stopped
                        output = [...output, this.formatString(task.title, chalk_1.default.red(figures_1.default.main.squareSmallFilled), level)];
                    }
                }
                // task should not have subtasks since subtasks will handle the error already
                // maybe it is a better idea to show the error or skip messages when show subtasks is disabled.
                if (!task.hasSubtasks() || !this.options.showSubtasks) {
                    // without the collapse option for skip and errors
                    if (task.hasFailed() && this.options.collapseErrors === false && (this.options.showErrorMessage || !this.options.showSubtasks)) {
                        // show skip data if collapsing is not defined
                        output = [...output, ...this.dumpData(task, level, 'error')];
                    }
                    else if (task.isSkipped() && this.options.collapseSkips === false && (this.options.showSkipMessage || !this.options.showSubtasks)) {
                        // show skip data if collapsing is not defined
                        output = [...output, ...this.dumpData(task, level, 'skip')];
                    }
                }
                // Current Task Output
                if (task === null || task === void 0 ? void 0 : task.output) {
                    if (task.isPending() && task.isPrompt()) {
                        // data output to prompt bar if prompt
                        this.promptBar = task.output;
                    }
                    else if (this.isBottomBar(task) || !task.hasTitle()) {
                        // data output to bottom bar
                        const data = this.dumpData(task, -1);
                        // create new if there is no persistent storage created for bottom bar
                        if (!this.bottomBar[task.id]) {
                            this.bottomBar[task.id] = {};
                            this.bottomBar[task.id].data = [];
                            const bottomBar = this.getTaskOptions(task).bottomBar;
                            if (typeof bottomBar === 'boolean') {
                                this.bottomBar[task.id].items = 1;
                            }
                            else {
                                this.bottomBar[task.id].items = bottomBar;
                            }
                        }
                        // persistent bottom bar and limit items in it
                        if (!(data === null || data === void 0 ? void 0 : data.some((element) => this.bottomBar[task.id].data.includes(element))) && !task.isSkipped()) {
                            this.bottomBar[task.id].data = [...this.bottomBar[task.id].data, ...data];
                        }
                    }
                    else if (task.isPending() || this.hasPersistentOutput(task)) {
                        // keep output if persistent output is set
                        output = [...output, ...this.dumpData(task, level)];
                    }
                }
                // render subtasks, some complicated conditionals going on
                if (
                // check if renderer option is on first
                this.options.showSubtasks !== false &&
                    // if it doesnt have subtasks no need to check
                    task.hasSubtasks() &&
                    (task.isPending() ||
                        task.hasFailed() ||
                        task.isCompleted() && !task.hasTitle() ||
                        // have to be completed and have subtasks
                        task.isCompleted() && this.options.collapse === false && !task.subtasks.some((subtask) => subtask.rendererOptions.collapse === true) ||
                        // if any of the subtasks have the collapse option of
                        task.subtasks.some((subtask) => subtask.rendererOptions.collapse === false) ||
                        // if any of the subtasks has failed
                        task.subtasks.some((subtask) => subtask.hasFailed()))) {
                    // set level
                    const subtaskLevel = !task.hasTitle() ? level : level + 1;
                    // render the subtasks as in the same way
                    const subtaskRender = this.multiLineRenderer(task.subtasks, subtaskLevel);
                    if ((subtaskRender === null || subtaskRender === void 0 ? void 0 : subtaskRender.trim()) !== '' && !task.subtasks.every((subtask) => !subtask.hasTitle())) {
                        output = [...output, subtaskRender];
                    }
                }
                // after task is finished actions
                if (task.isCompleted() || task.hasFailed() || task.isSkipped()) {
                    // clean up prompts
                    this.promptBar = null;
                    // clean up bottom bar items if not indicated otherwise
                    if (!this.hasPersistentOutput(task)) {
                        delete this.bottomBar[task.id];
                    }
                }
            }
        }
        if (output.length > 0) {
            return output.join(os_1.EOL);
        }
        else {
            return;
        }
    }
    renderBottomBar() {
        // parse through all objects return only the last mentioned items
        if (Object.keys(this.bottomBar).length > 0) {
            this.bottomBar = Object.keys(this.bottomBar).reduce((o, key) => {
                if (!(o === null || o === void 0 ? void 0 : o[key])) {
                    o[key] = {};
                }
                o[key] = this.bottomBar[key];
                this.bottomBar[key].data = this.bottomBar[key].data.slice(-this.bottomBar[key].items);
                o[key].data = this.bottomBar[key].data;
                return o;
            }, {});
            return Object.values(this.bottomBar)
                .reduce((o, value) => o = [...o, ...value.data], [])
                .join(os_1.EOL);
        }
    }
    renderPrompt() {
        if (this.promptBar) {
            return this.promptBar;
        }
    }
    dumpData(task, level, source = 'output') {
        const output = [];
        let data;
        switch (source) {
            case 'output':
                data = task.output;
                break;
            case 'skip':
                data = task.message.skip;
                break;
            case 'error':
                data = task.message.error;
                break;
        }
        // dont return anything on some occasions
        if (task.hasTitle() && source === 'error' && data === task.title) {
            return;
        }
        if (typeof data === 'string' && data.trim() !== '') {
            // indent and color
            data
                .split(os_1.EOL)
                .filter(Boolean)
                .forEach((line, i) => {
                const icon = i === 0 ? this.getSymbol(task, true) : ' ';
                output.push(this.formatString(line, icon, level + 1));
            });
        }
        return output;
    }
    formatString(string, icon, level) {
        var _a;
        return `${cli_truncate_1.default(indent_string_1.default(`${icon} ${string.trim()}`, level * this.options.indentation), (_a = process.stdout.columns) !== null && _a !== void 0 ? _a : 80)}`;
    }
    // eslint-disable-next-line complexity
    getSymbol(task, data = false) {
        var _a;
        if (task.isPending() && !data) {
            return ((_a = this.options) === null || _a === void 0 ? void 0 : _a.lazy) || this.options.showSubtasks !== false && task.hasSubtasks() && !task.subtasks.every((subtask) => !subtask.hasTitle())
                ? chalk_1.default.yellow(figures_1.default.main.pointer)
                : chalk_1.default.yellowBright(this.spinner[this.spinnerPosition]);
        }
        if (task.isCompleted() && !data) {
            if (task.hasSubtasks() && task.subtasks.some((subtask) => subtask.hasFailed())) {
                return chalk_1.default.yellow(figures_1.default.main.warning);
            }
            return chalk_1.default.green(figures_1.default.main.tick);
        }
        if (task.hasFailed() && !data) {
            return task.hasSubtasks() ? chalk_1.default.red(figures_1.default.main.pointer) : chalk_1.default.red(figures_1.default.main.cross);
        }
        if (task.isSkipped() && !data && this.options.collapseSkips === false) {
            return chalk_1.default.yellow(figures_1.default.main.warning);
        }
        else if (task.isSkipped() && (data || this.options.collapseSkips)) {
            return chalk_1.default.yellow(figures_1.default.main.arrowDown);
        }
        if (!data) {
            return chalk_1.default.dim(figures_1.default.main.squareSmallFilled);
        }
        else {
            return figures_1.default.main.pointerSmall;
        }
    }
}
exports.DefaultRenderer = DefaultRenderer;
/** designates whether this renderer can output to a non-tty console */
DefaultRenderer.nonTTY = false;
/** renderer options for the defauult renderer */
DefaultRenderer.rendererOptions = {
    indentation: 2,
    clearOutput: false,
    showSubtasks: true,
    collapse: true,
    collapseSkips: true,
    showSkipMessage: true,
    suffixSkips: true,
    collapseErrors: true,
    showErrorMessage: true,
    lazy: false,
    showTimer: false
};
