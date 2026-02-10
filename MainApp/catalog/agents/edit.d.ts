

export interface TStore extends IElement {
	readonly Id: number;
	readonly IsSystem: boolean;
	Name: string;
	Memo: string;
	readonly IsFolder: boolean;
	Parent: TStore;
}


export interface TAgent extends IElement {
	readonly Id: number;
	readonly IsSystem: boolean;
	Name: string;
	Date: Date;
	Memo: string;
	Store: TStore;
}   

export interface TRoot extends IRoot {
    readonly Agent: TAgent; 
}