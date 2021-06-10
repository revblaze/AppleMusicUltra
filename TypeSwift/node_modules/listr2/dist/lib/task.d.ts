import { Subject } from 'rxjs';
import { ListrContext, ListrEvent, ListrGetRendererOptions, ListrGetRendererTaskOptions, ListrOptions, ListrRendererFactory, ListrTask, ListrTaskObject, ListrTaskWrapper, PromptError } from '../interfaces/listr.interface';
import { StateConstants } from '../interfaces/state.constants';
import { Listr } from '../index';
import { PromptInstance } from '../utils/prompt.interface';
/**
 * Create a task from the given set of variables and make it runnable.
 */
export declare class Task<Ctx, Renderer extends ListrRendererFactory> extends Subject<ListrEvent> implements ListrTaskObject<ListrContext, Renderer> {
    listr: Listr<Ctx, any, any>;
    tasks: ListrTask<Ctx, any>;
    options: ListrOptions;
    rendererOptions: ListrGetRendererOptions<Renderer>;
    id: ListrTaskObject<Ctx, Renderer>['id'];
    task: ListrTaskObject<Ctx, Renderer>['task'];
    skip: ListrTaskObject<Ctx, Renderer>['skip'];
    subtasks: ListrTaskObject<Ctx, any>['subtasks'];
    state: ListrTaskObject<Ctx, Renderer>['state'];
    output: ListrTaskObject<Ctx, Renderer>['output'];
    title: ListrTaskObject<Ctx, Renderer>['title'];
    message: ListrTaskObject<Ctx, Renderer>['message'];
    prompt: undefined | PromptInstance | PromptError;
    exitOnError: boolean;
    rendererTaskOptions: ListrGetRendererTaskOptions<Renderer>;
    renderHook$: Subject<void>;
    private enabled;
    private enabledFn;
    constructor(listr: Listr<Ctx, any, any>, tasks: ListrTask<Ctx, any>, options: ListrOptions, rendererOptions: ListrGetRendererOptions<Renderer>);
    set state$(state: StateConstants);
    set output$(data: string);
    set message$(data: ListrTaskObject<Ctx, Renderer>['message']);
    set title$(title: string);
    check(ctx: Ctx): Promise<void>;
    hasSubtasks(): boolean;
    isPending(): boolean;
    isSkipped(): boolean;
    isCompleted(): boolean;
    hasFailed(): boolean;
    isEnabled(): boolean;
    hasTitle(): boolean;
    isPrompt(): boolean;
    run(context: Ctx, wrapper: ListrTaskWrapper<Ctx, Renderer>): Promise<void>;
}
