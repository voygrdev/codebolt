require('dotenv').config();
import Anthropic from "@anthropic-ai/sdk";

const anthropic = new Anthropic();

async function main(){
    const msg = await anthropic.messages.stream({
        model:"claude-3-5-sonnet-20241022",
        max_tokens: 1000,
        messages:[{
            role: 'user',
            content:'Hello'
        }]
    }).on('text', (text) => {
        console.log(text)
    })
    console.log(msg)
}

main()