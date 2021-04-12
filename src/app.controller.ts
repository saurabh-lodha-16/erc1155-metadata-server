import { Controller, Get, Param } from '@nestjs/common';
import { AppService } from './app.service';

@Controller()
export class AppController {
  constructor(private readonly appService: AppService) {}

  @Get('/:id')
  getMetadata(@Param('id') id: string): string {
    return this.appService.getMetadata(id);
  }
}
