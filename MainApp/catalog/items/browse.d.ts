export interface TItem extends IArrayElement {
	readonly Id: number;
	readonly IsSystem: boolean;
	Name: string;
	VatRate: string;
	Memo: string;
}

declare type TItems = IElementArray<TItem>;

export interface TRoot extends IRoot {
    readonly Items: TItems;
}