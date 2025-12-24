

export interface TUnit extends IElement {
	readonly Id: number;
	readonly IsSystem: boolean;
	Name: string;
	Short: string;
	Memo: string;
}

export interface TItem extends IArrayElement {
	readonly Id: number;
	readonly IsSystem: boolean;
	Name: string;
	Unit: TUnit;
	VatRate: string;
	Memo: string;
}

declare type TItems = IElementArray<TItem>;

export interface TRoot extends IRoot {
    readonly Items: TItems;
}