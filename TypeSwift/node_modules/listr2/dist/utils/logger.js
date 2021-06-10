"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.Logger = void 0;
/* eslint-disable no-console */
const figures_1 = __importDefault(require("figures"));
const logger_constants_1 = require("./logger.constants");
const chalk_1 = __importDefault(require("./chalk"));
/**
 * A internal logger for using in the verbose renderer mostly.
 */
class Logger {
    constructor(options) {
        this.options = options;
    }
    fail(message) {
        message = this.parseMessage(logger_constants_1.LogLevels.fail, message);
        console.error(message);
    }
    skip(message) {
        message = this.parseMessage(logger_constants_1.LogLevels.skip, message);
        console.info(message);
    }
    success(message) {
        message = this.parseMessage(logger_constants_1.LogLevels.success, message);
        console.log(message);
    }
    data(message) {
        message = this.parseMessage(logger_constants_1.LogLevels.data, message);
        console.info(message);
    }
    start(message) {
        message = this.parseMessage(logger_constants_1.LogLevels.start, message);
        console.log(message);
    }
    title(message) {
        message = this.parseMessage(logger_constants_1.LogLevels.title, message);
        console.info(message);
    }
    parseMessage(level, message) {
        // parse multi line messages
        let multiLineMessage;
        try {
            multiLineMessage = message.split('\n');
        }
        catch /* istanbul ignore next */ {
            multiLineMessage = [message];
        }
        multiLineMessage = multiLineMessage.map((msg) => {
            // format messages
            return this.logColoring({
                level,
                message: msg
            });
        });
        // join back multi line messages
        message = multiLineMessage.join('\n');
        return message;
    }
    logColoring({ level, message }) {
        var _a, _b, _c, _d, _e, _f;
        let icon;
        // do the coloring
        let coloring = (input) => {
            return input;
        };
        switch (level) {
            case logger_constants_1.LogLevels.fail:
                /* istanbul ignore if */
                if ((_a = this.options) === null || _a === void 0 ? void 0 : _a.useIcons) {
                    coloring = chalk_1.default.red;
                    icon = figures_1.default.main.cross;
                }
                else {
                    icon = '[FAILED]';
                }
                break;
            case logger_constants_1.LogLevels.skip:
                /* istanbul ignore if */
                if ((_b = this.options) === null || _b === void 0 ? void 0 : _b.useIcons) {
                    coloring = chalk_1.default.yellow;
                    icon = figures_1.default.main.arrowDown;
                }
                else {
                    icon = '[SKIPPED]';
                }
                break;
            case logger_constants_1.LogLevels.success:
                /* istanbul ignore if */
                if ((_c = this.options) === null || _c === void 0 ? void 0 : _c.useIcons) {
                    coloring = chalk_1.default.green;
                    icon = figures_1.default.main.tick;
                }
                else {
                    icon = '[SUCCESS]';
                }
                break;
            case logger_constants_1.LogLevels.data:
                /* istanbul ignore if */
                if ((_d = this.options) === null || _d === void 0 ? void 0 : _d.useIcons) {
                    icon = figures_1.default.main.arrowRight;
                }
                else {
                    icon = '[DATA]';
                }
                break;
            case logger_constants_1.LogLevels.start:
                /* istanbul ignore if */
                if ((_e = this.options) === null || _e === void 0 ? void 0 : _e.useIcons) {
                    icon = figures_1.default.main.pointer;
                }
                else {
                    icon = '[STARTED]';
                }
                break;
            case logger_constants_1.LogLevels.title:
                /* istanbul ignore if */
                if ((_f = this.options) === null || _f === void 0 ? void 0 : _f.useIcons) {
                    icon = figures_1.default.main.checkboxOn;
                }
                else {
                    icon = '[TITLE]';
                }
                break;
        }
        return coloring(`${icon} ${message}`);
    }
}
exports.Logger = Logger;
