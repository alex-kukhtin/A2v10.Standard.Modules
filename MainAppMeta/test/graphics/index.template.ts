

const template: Template = {
    delegates: {
        drawGraphics
    }
};

export default template;

function drawGraphics(g) {
    console.dir(g);
    const width = 300;
    const height = 70;
    const margin = { top: 10, right: 10, bottom: 10, left: 10};

    const chart = g.append('svg')
        .attr('viewBox', `${- margin.left} ${-margin.top} ${width + margin.left + margin.right} ${height + margin.top + margin.bottom}`);

    chart.append('text')
        .attr('x', 10)
        .attr('y', 10)
        .attr('style', 'font-size:1.1rem')
        .attr('fill', '#999')
        .text('DRAW TEXT');

}