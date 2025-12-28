

export interface TOperation extends IElement {
	readonly Id: number;
	Name: string;
	Url: string;
	Category: string;
}
export interface TAgent extends IElement {
	readonly Id: number;
	readonly IsSystem: boolean;
	Name: string;
	Date: Date;
	Memo: string;
	Store: TStore;
}
export interface TStore extends IElement {
	readonly Id: number;
	readonly IsSystem: boolean;
	Name: string;
	Memo: string;
	readonly IsFolder: boolean;
	Parent: TStore;
}

export interface TDocument extends IArrayElement {
	readonly Id: number;
	Done: boolean;
	Date: Date;
	Number: string;
	Operation: TOperation;
	Name: string;
	Sum: number;
	Memo: string;
	Agent: TAgent;
	StoreFrom: TStore;
	StoreTo: TStore;
}

declare type TDocumentArray = IElementArray<TDocument>;

export interface TRoot extends IRoot {
    readonly Documents: TDocumentArray;
}