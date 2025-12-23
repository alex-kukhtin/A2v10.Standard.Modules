
export interface TItem extends IElement {
	readonly Id: number;
	readonly IsSystem: boolean;
	Name: string;
	VatRate: string;
	Memo: string;
}   

export interface TRoot extends IRoot {
    readonly Item: TItem; 
}