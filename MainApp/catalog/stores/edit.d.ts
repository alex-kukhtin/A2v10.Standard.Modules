

export interface TStore extends IElement {
	readonly Id: number;
	readonly IsSystem: boolean;
	Name: string;
	Memo: string;
	readonly IsFolder: boolean;
	Parent: TStore;
}


export interface TAddress extends IArrayElement {
	readonly Id: number;
	Parent: TStore;
	RowNo: number;
	Text: string;
}

export interface TAddressArray extends IElementArray<TAddress> {

}


export interface TStore extends IElement {
	readonly Id: number;
	readonly IsSystem: boolean;
	Name: string;
	Memo: string;
	readonly IsFolder: boolean;
	Parent: TStore;
}   

export interface TRoot extends IRoot {
    readonly Store: TStore; 
}